# ============================================================================ #
#                                   #
# ============================================================================ #

variable "linux_vm_configuration" {
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