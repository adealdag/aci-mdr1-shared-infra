variable "fabric_nodes" {
  description = "List of fabric nodes part of the fabric, including leafs, spines and controllers. The key of each item is the node ID. The node_role can be: unspecified, leaf, spine, apic. The node_type can be unspecified or remote-leaf-wan"
  default     = {}
  type = map(object({
    name        = string
    serial      = string
    pod_id      = string
    node_role   = string
    node_type   = string
    oob_ip_addr = string
    inb_ip_addr = string
  }))
}

variable "fabric_management_oob" {
  description = "Parameters for the oob management configuration of the fabric"
  type = object({
    epg_name   = string
    gateway_ip = string
  })
}

variable "fabric_management_inb" {
  description = "Parameters for the inb management configuration of the fabric."
  type = object({
    epg_name         = string
    gateway_ip       = string
    gateway_mask_len = string
    vlan_encap       = string
  })
}

variable "vpc_domain" {
  description = "List of Virtual Port Channels (vPC) domains in the fabric. The key of each item is the VPC ID."
  default     = {}
  type = map(object({
    left_node_id  = string
    right_node_id = string
  }))
}