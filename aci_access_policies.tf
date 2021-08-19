resource "aci_leaf_interface_profile" "leaf_if_profile" {
  for_each = var.leaf_switches

  name = "leaf_${each.key}"
}

resource "aci_leaf_profile" "leaf_profile" {
  for_each = var.leaf_switches

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
  relation_infra_rs_acc_card_p = [aci_leaf_interface_profile.leaf_if_profile[each.key].name]
}