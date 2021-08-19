variable "leaf_switches" {
  description = "List of leaf switches part of the fabric. The key of each item is the leaf ID"
  default = {}
  type = map(object({
    name        = string
    oob_ip_mask = string
    inb_ip_mask = string
  }))
}

variable "spine_switches" {
  description = "List of spine switches part of the fabric. The key of each item is the leaf ID"
  default = {}
  type = map(object({
    name        = string
    oob_ip_mask = string
    inb_ip_mask = string
  }))
}

variable "vpc_domain" {
  description = "List of Virtual Port Channels (vPC) domains in the fabric. The key of each item is the VPC ID."
  default = {}
  type = map(object({
    left_node_id  = string
    right_node_id = string
  }))
}

