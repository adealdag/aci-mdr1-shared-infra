terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "0.7.1"
    }
  }
}

resource "aci_vmm_domain" "vmm" {
  provider_profile_dn = "uni/vmmp-VMware"
  name                = var.name
  access_mode         = "read-write"
  enable_ave          = "no"
  enable_tag          = "yes"
  encap_mode          = "vlan"
  ep_ret_time         = "0"
  mode                = "default"
  pref_encap_mode     = "vlan"

  relation_infra_rs_vlan_ns = var.vlan_pool_dn

  relation_vmm_rs_default_cdp_if_pol   = var.vswitch.cdp_if_pol_dn
  relation_vmm_rs_default_lldp_if_pol  = var.vswitch.lldp_if_pol_dn
  relation_vmm_rs_default_lacp_lag_pol = var.vswitch.lacp_if_pol_dn
}

resource "aci_vmm_credential" "vc" {
  vmm_domain_dn = aci_vmm_domain.vmm.id
  name          = "${var.name}_cred"
  pwd           = var.vc_password
  usr           = var.vc_username
}

resource "aci_vmm_controller" "vc" {
  vmm_domain_dn     = aci_vmm_domain.vmm.id
  name              = "${var.name}_ctrller"
  dvs_version       = var.dvs_version
  host_or_ip        = var.vc_host_or_ip
  inventory_trig_st = "untriggered"
  mode              = "default"
  port              = "0"
  root_cont_name    = var.vc_datacenter
  scope             = "vm"
  stats_mode        = var.stats_collection

  relation_vmm_rs_acc       = aci_vmm_credential.vc.id
  relation_vmm_rs_mgmt_e_pg = var.management_epg_dn
  # vmm_rs_to_ext_dev_mgr = 
}




