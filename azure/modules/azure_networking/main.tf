resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet_configuration
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = each.value.address_space
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_configuration
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet].name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_public_ip" "pub-ip" {
  name                = "az-firewall-pubip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "az-firewall" {
  name                = var.az_firewall_configuration.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"

  ip_configuration {
    name              = "az-firewall-primary-pub-ip"
    subnet_id         = azurerm_subnet.subnet["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.pub-ip.id
  }
}

/*
resource "azurerm_route_table" "firewall_route_table" {
  name                = var.firewall_route_table.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name           = "default_to_firewall"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  tags = {
    environment = "Production"
  }
}
*/
