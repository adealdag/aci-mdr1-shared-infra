variable "aci_url" {
    description = "URL for CISCO APIC"
}

variable "aci_username" {
  description = "This is the Cisco APIC username, which is required to authenticate with CISCO APIC"
  default = "terraform"
}

variable "aci_password" {
  description = "Password of the user mentioned in username argument. It is required when you want to use token-based authentication."
}