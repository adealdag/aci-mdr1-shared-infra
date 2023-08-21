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
  1103 = {
    name        = "LEAF1103"
    serial      = "FDO25300DH9"
    pod_id      = 1
    node_role   = "leaf"
    node_type   = "unspecified"
    oob_ip_addr = "10.50.3.116/24"
    inb_ip_addr = "172.16.101.103/24"
  },
  1104 = {
    name        = "LEAF1104"
    serial      = "FDO2529122P"
    pod_id      = 1
    node_role   = "leaf"
    node_type   = "unspecified"
    oob_ip_addr = "10.50.3.117/24"
    inb_ip_addr = "172.16.101.104/24"
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
  1202 = {
    name        = "SPINE1202"
    serial      = "FDO24090XZM"
    pod_id      = 1
    node_role   = "spine"
    node_type   = "unspecified"
    oob_ip_addr = "10.50.3.119/24"
    inb_ip_addr = "172.16.101.202/24"
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
  epg_name   = "oob_mgmt_epg"
  gateway_ip = "10.50.3.1"
}

fabric_management_inb = {
  epg_name         = "inb_mgmt_epg"
  gateway_ip       = "172.16.101.1"
  gateway_mask_len = "24"
  vlan_encap       = "vlan-101"
}

vpc_domain = {
  1 = {
    left_node_id  = 1101
    right_node_id = 1102
  },
  2 = {
    left_node_id  = 1103
    right_node_id = 1104
  }
}
