resource "azurerm_virtual_network" "hub_vnet" {
  name = "hub_vnet"
  address_space = ["10.99.0.0/16"]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "spoke1_vnet" {
  name = "spoke1_vnet"
  address_space = ["10.100.0.0/16"]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "spoke2_vnet" {
  name = "spoke2_vnet"
  address_space = ["10.101.0.0/16"]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}