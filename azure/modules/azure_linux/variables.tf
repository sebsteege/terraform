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
#                               Interface NSG Confiugration                    #
# ============================================================================ #



# ============================================================================ #
#                               Virtual Machine Confiugration                  #
# ============================================================================ #

variable "linux_vm_configuration" {
  description = "Configuration for linux virtual machines"
  type = map(object({
    name             = string
    subnet           = string
    size             = string
    admin_username   = string
    key_file         = string
  }))
}