# Data Sources
data "aci_tenant" "mgmt" {
  name = "mgmt"
}

data "aci_vrf" "inb" {
  tenant_dn = data.aci_tenant.mgmt.id
  name      = "inb"
}

data "aci_l3_domain_profile" "core" {
  name = "core_l3dom"
}

# Out of Band Management
resource "aci_node_mgmt_epg" "oob_mgmt_epg" {
  type                  = "out_of_band"
  management_profile_dn = "uni/tn-mgmt/mgmtp-default"
  name                  = var.fabric_management_oob.epg_name
}

resource "aci_static_node_mgmt_address" "oob_ip_addr" {
  for_each = var.fabric_nodes

  management_epg_dn = aci_node_mgmt_epg.oob_mgmt_epg.id
  t_dn              = "topology/pod-${each.value.pod_id}/node-${each.key}"
  type              = "out_of_band"
  addr              = each.value.oob_ip_addr
  gw                = var.fabric_management_oob.gateway_ip
}

# In-Band Management
resource "aci_bridge_domain" "inb" {
  tenant_dn                = data.aci_tenant.mgmt.id
  relation_fv_rs_ctx       = data.aci_vrf.inb.id
  name                     = "inb"
  relation_fv_rs_bd_to_out = [module.inb_l3out.id]
}

resource "aci_subnet" "inb" {
  parent_dn = aci_bridge_domain.inb.id
  ip        = "${var.fabric_management_inb.gateway_ip}/${var.fabric_management_inb.gateway_mask_len}"
  scope     = ["public"]
}

resource "aci_node_mgmt_epg" "inb_mgmt_epg" {
  type                     = "in_band"
  management_profile_dn    = "uni/tn-mgmt/mgmtp-default"
  name                     = var.fabric_management_inb.epg_name
  encap                    = var.fabric_management_inb.vlan_encap
  relation_mgmt_rs_mgmt_bd = aci_bridge_domain.inb.id
  relation_fv_rs_prov      = [aci_contract.inb.id]
}

resource "aci_static_node_mgmt_address" "inb_ip_addr" {
  for_each = { for k, v in var.fabric_nodes : k => v if v.inb_ip_addr != "" }

  management_epg_dn = aci_node_mgmt_epg.inb_mgmt_epg.id
  t_dn              = "topology/pod-${each.value.pod_id}/node-${each.key}"
  type              = "in_band"
  addr              = each.value.inb_ip_addr
  gw                = var.fabric_management_inb.gateway_ip
}

module "inb_l3out" {
  source = "github.com/adealdag/terraform-aci-l3out?ref=v0.2.0"

  name      = "inb_l3out"
  tenant_dn = data.aci_tenant.mgmt.id
  vrf_dn    = data.aci_vrf.inb.id
  l3dom_dn  = data.aci_l3_domain_profile.core.id

  bgp = {
    enabled = true
  }

  nodes = {
    "1101" = {
      pod_id             = "1"
      node_id            = "1101"
      router_id          = "1.1.1.101"
      router_id_loopback = "no"
    },
    "1102" = {
      pod_id             = "1"
      node_id            = "1102"
      router_id          = "1.1.1.102"
      router_id_loopback = "no"
    }
  }

  interfaces = {
    "1101_1_25" = {
      l2_port_type     = "port"
      l3_port_type     = "sub-interface"
      pod_id           = "1"
      node_a_id        = "1101"
      interface_id     = "eth1/25"
      ip_addr_a        = "172.16.20.10/30"
      vlan_encap       = "vlan-20"
      vlan_encap_scope = "local"
      mode             = "regular"
      mtu              = "9216"

      bgp_peers = {
        "key" = {
          peer_ip_addr     = "172.16.20.9"
          peer_asn         = "65020"
          addr_family_ctrl = "af-ucast"
          bgp_ctrl         = "send-com,send-ext-com"
        }
      }
    },
    "1102_1_25" = {
      l2_port_type     = "port"
      l3_port_type     = "sub-interface"
      pod_id           = "1"
      node_a_id        = "1102"
      interface_id     = "eth1/25"
      ip_addr_a        = "172.16.20.14/30"
      vlan_encap       = "vlan-20"
      vlan_encap_scope = "local"
      mode             = "regular"
      mtu              = "9216"

      bgp_peers = {
        "key" = {
          peer_ip_addr     = "172.16.20.13"
          peer_asn         = "65020"
          addr_family_ctrl = "af-ucast"
          bgp_ctrl         = "send-com,send-ext-com"
        }
      }
    }
  }

  external_l3epg = {
    "default" = {
      name         = "default"
      pref_gr_memb = "exclude"
      subnets = {
        "default" = {
          prefix = "0.0.0.0/0"
          scope  = ["import-security"]
        }
      }
      cons_contracts = [aci_contract.inb.id]
    }
  }
}

# Inband Contract
resource "aci_contract" "inb" {
  tenant_dn = data.aci_tenant.mgmt.id
  name      = "inb_con"
  scope     = "context"
}

resource "aci_contract_subject" "inb_all" {
  contract_dn                  = aci_contract.inb.id
  name                         = "permit_all"
  relation_vz_rs_subj_filt_att = [aci_filter.any.id]
}

resource "aci_filter" "any" {
  tenant_dn = data.aci_tenant.mgmt.id
  name      = "any"
}

resource "aci_filter_entry" "ip_any_any" {
  filter_dn = aci_filter.any.id
  name      = "any"
  ether_t   = "ip"
  prot      = "unspecified"
}

# Inband Access Policies (for APIC)

resource "aci_attachable_access_entity_profile" "apic_aaep" {
  name                    = "apic_aaep"
  relation_infra_rs_dom_p = [aci_physical_domain.inb.id]
}

resource "aci_physical_domain" "inb" {
  name        = "inb_physdom"
  relation_infra_rs_vlan_ns = aci_vlan_pool.inb_vlan.id
}

resource "aci_vlan_pool" "inb_vlan" {
  name       = "inb_vlan"
  alloc_mode = "static"
}

resource "aci_ranges" "inb_vlan_block" {
  vlan_pool_dn = aci_vlan_pool.inb_vlan.id
  from         = var.fabric_management_inb.vlan_encap
  to           = var.fabric_management_inb.vlan_encap
  alloc_mode   = "static"
  role         = "external"
}

resource "aci_leaf_access_port_policy_group" "apic" {
  name = "access_apic"

  relation_infra_rs_cdp_if_pol  = aci_cdp_interface_policy.off.id
  relation_infra_rs_lldp_if_pol = aci_lldp_interface_policy.on.id
  relation_infra_rs_l2_if_pol   = aci_l2_interface_policy.global_scope.id
  relation_infra_rs_mcp_if_pol  = aci_miscabling_protocol_interface_policy.off.id
  relation_infra_rs_stp_if_pol  = aci_spanning_tree_interface_policy.default.id

  relation_infra_rs_att_ent_p = aci_attachable_access_entity_profile.apic_aaep.id
}

resource "aci_access_port_selector" "apic_port1" {
  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_if_profile["1101"].id
  description               = "Port connecting to apic"
  name                      = "eth1_1"
  access_port_selector_type = "range"

  relation_infra_rs_acc_base_grp = aci_leaf_access_port_policy_group.apic.id
}

resource "aci_access_port_block" "apic_port1" {
  access_port_selector_dn = aci_access_port_selector.apic_port1.id
  name                    = "eth1_1"
  from_card               = "1"
  from_port               = "1"
  to_card                 = "1"
  to_port                 = "1"
}

resource "aci_access_port_selector" "apic_port2" {
  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_if_profile["1102"].id
  description               = "Port connecting to apic"
  name                      = "eth1_1"
  access_port_selector_type = "range"

  relation_infra_rs_acc_base_grp = aci_leaf_access_port_policy_group.apic.id
}

resource "aci_access_port_block" "apic_port2" {
  access_port_selector_dn = aci_access_port_selector.apic_port2.id
  name                    = "eth1_1"
  from_card               = "1"
  from_port               = "1"
  to_card                 = "1"
  to_port                 = "1"
}