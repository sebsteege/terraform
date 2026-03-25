resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

module "azure_networking" {
  source = "./modules/azure_networking"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  vnet_configuration = var.vnet_configuration
  subnet_configuration = var.subnet_configuration
  az_firewall_configuration = var.az_firewall_configuration
  lng_configuration = var.lng_configuration
  vng_configuration = var.vng_configuration
  vng_connection_settings = var.vng_connection_settings
}

/*
module "azure_linux" {
  source = "./modules/azure_linux"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  linux_vm_configuration = var.linux_vm_configuration
}
*/