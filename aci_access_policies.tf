# Leaf Switches Profiles and Interface Profiles

resource "aci_leaf_interface_profile" "leaf_if_profile" {
  for_each = { for k, v in var.fabric_nodes: k => v if v.node_role == "leaf"}

  name = "leaf_${each.key}"
}

resource "aci_leaf_profile" "leaf_profile" {
  for_each = { for k, v in var.fabric_nodes: k => v if v.node_role == "leaf"}

  name = "leaf_${each.key}"
  leaf_selector {
    name                    = "leaf_${each.key}"
    switch_association_type = "range"
    node_block {
      name  = each.key
      from_ = each.key
      to_   = each.key
    }
  }
  relation_infra_rs_acc_port_p = [aci_leaf_interface_profile.leaf_if_profile[each.key].id]
}

# VPC Domains

resource "aci_vpc_explicit_protection_group" "vpc_domain" {
  for_each = var.vpc_domain

  name                              = "vpc_${each.key}"
  switch1                           = each.value.left_node_id
  switch2                           = each.value.right_node_id
  vpc_explicit_protection_group_id  = each.key
}

# Standard Interface Policies

resource "aci_cdp_interface_policy" "on" {
  name        = "cdp_on"
  admin_st    = "enabled"
}

resource "aci_cdp_interface_policy" "off" {
  name        = "cdp_off"
  admin_st    = "disabled"
}

resource "aci_lldp_interface_policy" "on" {
  name        = "lldp_on"
  admin_rx_st = "enabled"
  admin_tx_st = "enabled"
} 

resource "aci_lldp_interface_policy" "off" {
  name        = "lldp_off"
  admin_rx_st = "disabled"
  admin_tx_st = "disabled"
} 

resource "aci_l2_interface_policy" "local_scope" {
  name        = "l2_local_scope"
  annotation  = "tag_l2_pol"
  qinq        = "disabled"
  vepa        = "disabled"
  vlan_scope  = "portlocal"
}

resource "aci_l2_interface_policy" "global_scope" {
  name        = "l2_global_scope"
  annotation  = "tag_l2_pol"
  qinq        = "disabled"
  vepa        = "disabled"
  vlan_scope  = "global"
}

resource "aci_miscabling_protocol_interface_policy" "on" {
  name        = "mcp_on"
  admin_st    = "enabled"
}

resource "aci_miscabling_protocol_interface_policy" "off" {
  name        = "mcp_off"
  admin_st    = "disabled"
}

resource "aci_spanning_tree_interface_policy" "default" {
  name  = "stp_default"
  ctrl = ["unspecified"]
}

resource "aci_spanning_tree_interface_policy" "filter" {
  name  = "stp_default"
  ctrl = ["bpdu-filter"]
}

resource "aci_spanning_tree_interface_policy" "guard" {
  name  = "stp_default"
  ctrl = ["bpdu-guard"]
}

resource "aci_spanning_tree_interface_policy" "filter_guard" {
  name  = "stp_default"
  ctrl = ["bpdu-filter", "bpdu-guard"]
}