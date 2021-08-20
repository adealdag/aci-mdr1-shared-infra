variable "name" {
    type = string
    description = "Name of the VMM Domain"
}

variable "vc_host_or_ip" {
    type = string
    description = "FQDN or IP address of the VMM Controller (vCenter)"
}

variable "vc_username" {
    type = string
    description = "Username to be used to connect to the VMM Controller (vCenter)"
}

variable "vc_password" {
    type = string
    sensitive = true
    description = "Password to be used to connect to the VMM Controller (vCenter)"
}

variable "vc_datacenter" {
    type = string
    description = "Datacenter object where the new DVS will be created"
}

variable "dvs_version" {
    type = string
    description = "Version of the new DVS that will be created. Allowed values are \"5.1\", \"5.5\", \"6.0\", \"6.5\", \"6.6\", \"7.0\" and \"unmanaged\""
}

variable "stats_collection" {
    type = string
    description = "Stats Collection mode. Allowed values are disabled, enabled and unknown"
}

variable "management_epg_dn" {
    type = string
    description = "Relation (dn) to the management EPG object that will be used to establish the connection to the controller"
}

variable "vlan_pool_dn" {
    type = string
    description = "Relation (dn) to the dynamic VLAN pool to be used for the VMM domain"
}

variable "vswitch" {
    type = object ({
        cdp_if_pol_dn = string
        lldp_if_pol_dn = string
        lacp_if_pol_dn = string
    })
    default = {
        cdp_if_pol_dn = ""
        lldp_if_pol_dn = ""
        lacp_if_pol_dn = ""      
    }
    description = "Virtual Switch configuration to override the configuration inherited from the access policies. Includes CDP, LLDP and LACP configuration. Leave empty to use inherited configuration"
}


