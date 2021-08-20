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
    vlans = [ {
      encap_from = "vlan-3000"
      encap_to = "vlan-3999"
    } ]
  }
}