esxi_nodes = {
  "hx_edge_1" = {
    name = "hx_edge_1"
    ports = [{
      node_id = 1101
      pod_id  = 1
      port_id = 11
      },
      {
        node_id = 1102
        pod_id  = 1
        port_id = 11
    }]
  },
  "hx_edge_2" = {
    name = "hx_edge_2"
    ports = [{
      node_id = 1101
      pod_id  = 1
      port_id = 12
      },
      {
        node_id = 1102
        pod_id  = 1
        port_id = 12
    }]
  },
  "hx_edge_3" = {
    name = "hx_edge_3"
    ports = [{
      node_id = 1101
      pod_id  = 1
      port_id = 13
      },
      {
        node_id = 1102
        pod_id  = 1
        port_id = 13
    }]
  }
}

vmm_domain = {
  "mdr1" = {
    name = "vmm_vds"
    vlans = [{
      encap_from = "vlan-3915"
      encap_to   = "vlan-3999"
    }]
    vc_host_or_ip = "10.50.3.240"
    vc_datacenter = "MDR1"
    dvs_version   = "6.5"
  }
}