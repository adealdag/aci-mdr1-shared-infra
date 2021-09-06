# Ports towards Nexus 9000 - Core
resource "aci_attachable_access_entity_profile" "main_aaep" {
  name                    = "main_aaep"
  relation_infra_rs_dom_p = []

  lifecycle {
    ignore_changes = [
      # Ignore changes to the list of domains attached to the AAEP
      relation_infra_rs_dom_p,
    ]
  }
}

resource "aci_leaf_access_port_policy_group" "core" {
  name  = "access_core"

  relation_infra_rs_cdp_if_pol  = aci_cdp_interface_policy.off.id
  relation_infra_rs_lldp_if_pol = aci_lldp_interface_policy.on.id
  relation_infra_rs_l2_if_pol   = aci_l2_interface_policy.global_scope.id
  relation_infra_rs_mcp_if_pol  = aci_miscabling_protocol_interface_policy.on.id
  relation_infra_rs_stp_if_pol  = aci_spanning_tree_interface_policy.filter_guard.id

  relation_infra_rs_att_ent_p = aci_attachable_access_entity_profile.main_aaep.id
}

resource "aci_access_port_selector" "core_1101_25" {
  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_if_profile["1101"].id
  description               = "Port connecting to core"
  name                      = "eth1_25"
  access_port_selector_type = "range"

  relation_infra_rs_acc_base_grp = aci_leaf_access_port_policy_group.core.id
}

resource "aci_access_port_block" "core_1101_25" {
  access_port_selector_dn = aci_access_port_selector.core_1101_25.id
  name                    = "eth1_25"
  from_card               = "1"
  from_port               = "25"
  to_card                 = "1"
  to_port                 = "25"
}

resource "aci_access_port_selector" "core_1102_25" {
  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_if_profile["1102"].id
  description               = "Port connecting to core"
  name                      = "eth1_25"
  access_port_selector_type = "range"

  relation_infra_rs_acc_base_grp = aci_leaf_access_port_policy_group.core.id
}

resource "aci_access_port_block" "core_1102_25" {
  access_port_selector_dn = aci_access_port_selector.core_1102_25.id
  name                    = "eth1_25"
  from_card               = "1"
  from_port               = "25"
  to_card                 = "1"
  to_port                 = "25"
}