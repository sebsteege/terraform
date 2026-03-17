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

resource "azurerm_route_table" "firewall_default_rt" {
  name                = "default_route_to_firewall"
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name           = "default_to_firewall"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.az-firewall.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "subnet_default_rt_ass" {
  for_each       = { for k, v in var.subnet_configuration : k=> v if v.vnet != "hub_vnet" }
  subnet_id      = azurerm_subnet.subnet[each.value.name].id
  route_table_id = azurerm_route_table.firewall_default_rt.id
}

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  for_each                  = { for k, v in var.vnet_configuration : k => v if v.name != "hub_vnet" }
  name                      = "hub-to-${each.value.name}-peering"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet["hub_vnet"].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[each.value.name].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  for_each                  = { for k, v in var.vnet_configuration : k => v if v.name != "hub_vnet" }
  name                      = "${each.value.name}-to-hub-peering"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet[each.value.name].name
  remote_virtual_network_id = azurerm_virtual_network.vnet["hub_vnet"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways = false
}