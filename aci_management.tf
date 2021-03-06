# Data Sources
data "aci_tenant" "mgmt" {
  name = "mgmt"
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
  tenant_dn = data.aci_tenant.mgmt.id
  name      = "inb"
}

resource "aci_subnet" "inb" {
  parent_dn   = aci_bridge_domain.inb.id
  ip          = "${var.fabric_management_inb.gateway_ip}/${var.fabric_management_inb.gateway_mask_len}"
  scope       = ["public"]
}

resource "aci_node_mgmt_epg" "inb_mgmt_epg" {
  type                     = "in_band"
  management_profile_dn    = "uni/tn-mgmt/mgmtp-default"
  name                     = var.fabric_management_inb.epg_name
  encap                    = var.fabric_management_inb.vlan_encap
  relation_mgmt_rs_mgmt_bd = aci_bridge_domain.inb.id
}

resource "aci_static_node_mgmt_address" "inb_ip_addr" {
  for_each = { for k, v in var.fabric_nodes : k => v if v.inb_ip_addr != "" }

  management_epg_dn = aci_node_mgmt_epg.inb_mgmt_epg.id
  t_dn              = "topology/pod-${each.value.pod_id}/node-${each.key}"
  type              = "in_band"
  addr              = each.value.inb_ip_addr
  gw                = var.fabric_management_inb.gateway_ip
}