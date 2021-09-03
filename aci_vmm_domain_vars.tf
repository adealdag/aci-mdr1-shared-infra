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

variable "vmm_domain" {
  description = "Attributes to configure VMM domain integration with VMware"
  default     = {}
  type = map(object({
    name = string
    vlans = list(object({
      encap_from = string
      encap_to   = string
    }))
    vc_host_or_ip = string
    vc_datacenter = string
    dvs_version = string
  }))
}