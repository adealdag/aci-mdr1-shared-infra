# Local variables
locals {
  esxi_ports = flatten([
    for node_key, node_attrs in var.esxi_nodes : [
      for port in node_attrs.ports : {
        node_key  = node_key
        node_name = node_attrs.name
        port      = port
  }]])
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
}

resource "aci_access_port_block" "port" {
  for_each = { for p in local.esxi_ports : format("%s_%s", p.port.node_id, p.port.port_id) => p }

  access_port_selector_dn = aci_access_port_selector.esxi[each.key].id
  name                    = "eth1_${each.value.port.port_id}"
  from_card               = "1"
  from_port               = each.value.port.port_id
  to_card                 = "1"
  to_port                 = each.value.port.port_id

  relation_infra_rs_acc_bndl_subgrp = aci_leaf_access_bundle_policy_group.esxi[each.value.node_key].id
}