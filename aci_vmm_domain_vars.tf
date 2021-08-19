variable "esxi_nodes" {
  description = "Attributes to connect the ESXi nodes to the fabric and to the VDS"
  type = map(object({
    name = string
    ports = list(object({
      pod_id  = string
      node_id = string
      port_id = string
    }))

  }))

}