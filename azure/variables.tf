# ============================================================================ #
#                   Azure Resource Group and Region Variables                  #
# ============================================================================ #

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

# ============================================================================ #
#                       Virtual Network Variables                              #
# ============================================================================ #

variable "vnet_configuration" {
  description = "Configuration for the virtual networks"
  type = map(object({
    name           = string
    address_space  = list(string)
  }))
}

# ============================================================================ #
#                                   Subnet Variables                           #
# ============================================================================ #

variable "subnet_configuration" {
  description = "Configuration for the subnet"
  type = map(object({
    name             = string
    vnet             = string
    address_prefixes = list(string)
    delegation       = optional(list(object({
        name    = string
        actions = list(string) 
    })))
  }))
}

# ============================================================================ #
#                           Azure Firewall Variables                           #
# ============================================================================ #

variable "az_firewall_configuration" {
  description = "Azure Firewall Configuration"
  type        = object(
  {
    firewall_name = string
    firewall_subnet = string
  })
}

# ============================================================================ #
#                        Azure On-Prem VPN Variables                           #
# ============================================================================ #

variable "lng_configuration" {
  description = "Configuration for Local Network Gateways"
  type = map(object({
    name             = string
    gateway_address  = string
    vnet             = string
    bgp_settings       = list(object({
        asn    = string
        bgp_peering_address = string
    }))
  }))
}

variable "vng_configuration" {
  description = "Configuration for Virtual Network Gateway"
  type = object({
    name             = string
    active_active = optional(string, "false")
    bgp_route_translation_for_nat_enabled = optional(string, "false")
    dns_forwarding_enabled = optional(string, "false")
    edge_zone = optional(string, "")
    private_ip_address_enabled = optional(string, "false")
    remote_vnet_traffic_enabled = optional(string, "false")
    sku = optional(string, "VpnGw1")    
    bgp_settings       = list(object({
        asn    = string
        apipa_address = string
    }))
  })
}

variable "vng_connection_settings" {
  description = "Settings for VPN Connection to on-prem"
  type = object({
    name             = string
    shared_key       = string
    local_network_gateway = string
    ipsec_policy = optional(list(object({
        dh_group         = optional(string)
        ike_encryption   = optional(string)
        ike_integrity    = optional(string)
        ipsec_encryption = optional(string)
        ipsec_integrity  = optional(string)
        pfs_group        = optional(string)
        sa_lifetime      = optional(string)
    })))
  })
}
