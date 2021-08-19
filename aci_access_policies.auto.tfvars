fabric_nodes = {
  1101 = {
    name        = "LEAF1101"
    serial      = "FDO25260KDF"
    pod_id      = 1
    node_role   = "leaf"
    node_type   = "unspecified"
    oob_ip_addr = "10.50.3.114/24"
    inb_ip_addr = "172.16.101.101/24"
  },
  1102 = {
    name        = "LEAF1102"
    serial      = "FDO25260KG0"
    pod_id      = 1
    node_role   = "leaf"
    node_type   = "unspecified"
    oob_ip_addr = "10.50.3.115/24"
    inb_ip_addr = "172.16.101.102/24"
  },
  1201 = {
    name        = "SPINE1201"
    serial      = "FDO25151AN1"
    pod_id      = 1
    node_role   = "spine"
    node_type   = "unspecified"
    oob_ip_addr = "10.50.3.118/24"
    inb_ip_addr = "172.16.101.201/24"
  },
  1 = {
    name        = "apic1-mdr1"
    serial      = "WZP251109FG"
    pod_id      = 1
    node_role   = "apic"
    node_type   = "unspecified"
    oob_ip_addr = "10.50.3.111/24"
    inb_ip_addr = "172.16.101.11/24"
  }
}

fabric_management_oob = {
  epg_name = "oob_mgmt_epg"
  gateway_ip = "10.50.3.1"
}

fabric_management_inb = {
  epg_name = "inb_mgmt_epg"
  gateway_ip = "172.16.101.1"
  vlan_encap = "vlan-101"
}