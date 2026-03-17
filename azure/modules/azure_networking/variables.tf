variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

variable "vnet_configuration" {
  description = "Configuration for the virtual networks"
  type = map(object({
    name           = string
    address_space  = list(string)
  }))
}

variable "subnet_configuration" {
  description = "Configuration for the subnet"
  type = map(object({
    name           = string
    vnet           = string
    address_prefixes = list(string)
    delegation     = optional(list(object({
        name    = string
        actions = list(string) 
    })))
  }))
}

variable "az_firewall_configuration" {
  description = "Azure Firewall Configuration"
  type        = object(
  {
    firewall_name = string
    firewall_subnet = string
  })
}