# Local variables
locals {
  esxi_ports = flatten([
    for node_key, node_attrs in var.esxi_nodes : [
      for port in node_attrs.ports : {
        node_key  = node_key
        node_name = node_attrs.name
        port      = port
  }]])

  vlan_ranges = flatten([
    for vmm_key, vmm_value in var.vmm_domain : [
      for range in vmm_value.vlans : {
        vmm_key = vmm_key
        from    = range.encap_from
        to      = range.encap_to
      }
    ]
  ])
}

# Access policies to connect HX nodes
resource "aci_leaf_access_bundle_policy_group" "esxi" {
  for_each = var.esxi_nodes

  name  = "vpc_${each.value.name}"
  lag_t = "node"

  relation_infra_rs_cdp_if_pol  = aci_cdp_interface_policy.off.id
  relation_infra_rs_lldp_if_pol = aci_lldp_interface_policy.on.id
  relation_infra_rs_lacp_pol    = aci_lacp_policy.macpin.id
  relation_infra_rs_l2_if_pol   = aci_l2_interface_policy.global_scope.id
  relation_infra_rs_mcp_if_pol  = aci_miscabling_protocol_interface_policy.on.id
  relation_infra_rs_stp_if_pol  = aci_spanning_tree_interface_policy.filter_guard.id

  # relation_infra_rs_att_ent_p = ""
}

resource "aci_access_port_selector" "esxi" {
  for_each = { for p in local.esxi_ports : format("%s_%s", p.port.node_id, p.port.port_id) => p }

  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_if_profile[each.value.port.node_id].id
  description               = "Port connecting to ${each.value.node_name}"
  name                      = "eth1_${each.value.port.port_id}"
  access_port_selector_type = "range"

  relation_infra_rs_acc_base_grp = aci_leaf_access_bundle_policy_group.esxi[each.value.node_key].id
}

resource "aci_access_port_block" "port" {
  for_each = { for p in local.esxi_ports : format("%s_%s", p.port.node_id, p.port.port_id) => p }

  access_port_selector_dn = aci_access_port_selector.esxi[each.key].id
  name                    = "eth1_${each.value.port.port_id}"
  from_card               = "1"
  from_port               = each.value.port.port_id
  to_card                 = "1"
  to_port                 = each.value.port.port_id
}

resource "aci_vlan_pool" "vmm_vmware" {
  for_each = var.vmm_domain

  name       = "${each.value.name}_vlan"
  alloc_mode = "dynamic"
}

resource "aci_ranges" "vlan_block" {
  for_each = { for r in local.vlan_ranges : format("%s_%s_%s", r.vmm_key, r.from, r.to) => r }

  vlan_pool_dn = aci_vlan_pool.vmm_vmware[each.value.vmm_key].id
  from         = each.value.from
  to           = each.value.to
  alloc_mode   = "dynamic"
  role         = "external"
}

module "vmm_domain_vmware" {
  source = "./module_aci_vmm_domain"
  for_each = var.vmm_domain

  name = each.value.name
  vc_host_or_ip = "10.50.3.240"
  vc_username = var.vcenter_username
  vc_password = var.vcenter_password
  vc_datacenter = "MDR1"
  dvs_version = "6.5"
  stats_collection = "enabled"
  management_epg_dn = aci_node_mgmt_epg.oob_mgmt_epg.id
  vlan_pool_dn = aci_vlan_pool.vmm_vmware[each.key].id
}

resource "null_resource" "attach_esxi_dvs" {
  depends_on = [
    module.vmm_domain_vmware["mdr1"]
  ]

  provisioner "local-exec" {
    command = "ansible-galaxy collection install community.vmware"
    working_dir = "ansible"
    interpreter = [
      "/bin/bash", "-c"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.yaml attach_hosts_vds.yaml"
    working_dir = "ansible"
    interpreter = [
      "/bin/bash", "-c"
    ]
    environment = {
      VMWARE_HOST = "vcsa-mdr1.cisco.com"
      VMWARE_USER = var.vcenter_username
      VMWARE_PASSWORD = var.vcenter_password
     }
  }
}