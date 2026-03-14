resource "azurerm_subnet" "public_subnet" { 
  name = "public_subnet"
  address_prefixes = ["10.99.0.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
}

resource "azurerm_subnet" "private_subnet" {  
  name = "private_subnet"
  address_prefixes = ["10.99.1.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
}

resource "azurerm_subnet" "spoke1_subnet_a" {
  name = "spoke1_subnet_a"
  address_prefixes = ["10.100.0.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
}

resource "azurerm_subnet" "spoke1_subnet_b" {
  name = "spoke1_subnet_b"
  address_prefixes = ["10.100.1.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
}

resource "azurerm_subnet" "spoke2_subnet_a" {
  name = "spoke2_subnet_a"
  address_prefixes = ["10.101.0.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
}

resource "azurerm_subnet" "spoke2_subnet_b" {
  name = "spoke2_subnet_b"
  address_prefixes = ["10.101.1.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
}