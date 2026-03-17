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
}
