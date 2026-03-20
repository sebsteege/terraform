# ============================================================================ #
#                       Virtual Network Configuration                          #
# ============================================================================ #

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet_configuration
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = each.value.address_space
}

# ============================================================================ #
#                           Subnet Configuration                               #
# ============================================================================ #

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_configuration
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet].name
  address_prefixes     = each.value.address_prefixes
}

# ============================================================================ #
#                       Azure Firewall Configuration                           #
# ============================================================================ #

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

# ============================================================================ #
#                           Azure UDR Configuration                            #
# ============================================================================ #

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

resource "azurerm_route_table" "firewall_inbound_rt" {
  name                = "firewall_inbound_route_from_on-prem"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "route" { # a dynamic block is used to iterate over nested blocks inside a top level block
    for_each       = { for k, v in var.subnet_configuration : k => v if v.vnet != "hub_vnet" }
    content {
      name           = azurerm_subnet.subnet[route.value.name].name # in a dynamic block the iterator is named after the block
      address_prefix = azurerm_subnet.subnet[route.value.name].address_prefixes[0]
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = azurerm_firewall.az-firewall.ip_configuration[0].private_ip_address
     }
  }
}

resource "azurerm_subnet_route_table_association" "subnet_default_rt_ass" {
  for_each       = { for k, v in var.subnet_configuration : k=> v if v.vnet != "hub_vnet" }
  subnet_id      = azurerm_subnet.subnet[each.value.name].id
  route_table_id = azurerm_route_table.firewall_default_rt.id
}

resource "azurerm_subnet_route_table_association" "subnet_inbound_rt_ass" {
  subnet_id      = azurerm_subnet.subnet["GatewaySubnet"].id
  route_table_id = azurerm_route_table.firewall_inbound_rt.id
}

# ============================================================================ #
#                       Virtual Network Peering                                #
# ============================================================================ #

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

# ============================================================================ #
#                    Azure On-Prem VPN Configuration                           #
# ============================================================================ #

resource "azurerm_local_network_gateway" "lng" {
  for_each = var.lng_configuration
  gateway_address     = each.value.gateway_address
  location            = var.location
  name                = each.value.name
  resource_group_name = var.resource_group_name
  bgp_settings {
    asn                 = each.value.bgp_settings[0].asn
    bgp_peering_address = each.value.bgp_settings[0].bgp_peering_address
  }
}

resource "azurerm_public_ip" "vng-pub-ip" {
  name                = "vng-pubip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vng" {
  name                                  = var.vng_configuration.name
  active_active                         = false
  bgp_route_translation_for_nat_enabled = false
  dns_forwarding_enabled                = false
  bgp_enabled                           = true
  generation                            = "Generation2"
  ip_sec_replay_protection_enabled      = true
  location                              = var.location
  private_ip_address_enabled            = false
  remote_vnet_traffic_enabled           = false
  resource_group_name                   = var.resource_group_name
  sku                                   = "VpnGw2"
  type                                  = "Vpn"
  virtual_wan_traffic_enabled           = false
  vpn_type                              = "RouteBased"
  bgp_settings {
    asn         = var.vng_configuration.bgp_settings[0].asn
    peer_weight = 0
    peering_addresses {
      apipa_addresses       = [var.vng_configuration.bgp_settings[0].apipa_address]
      ip_configuration_name = "default"
    }
  }
  ip_configuration {
    name                          = "default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vng-pub-ip.id
    subnet_id                     = azurerm_subnet.subnet["GatewaySubnet"].id
  }
}

resource "azurerm_virtual_network_gateway_connection" "azure_to_cvlab" {
  name                = var.vng_connection_settings.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type                            = "IPsec"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vng.id
  local_network_gateway_id = azurerm_local_network_gateway.lng[var.vng_connection_settings.local_network_gateway].id
  bgp_enabled = true
  custom_bgp_addresses {
    primary = var.vng_configuration.bgp_settings[0].apipa_address
  }
  shared_key = var.vng_connection_settings.shared_key

  ipsec_policy {
    dh_group = try(var.vng_connection_settings.ipsec_policy[0].dh_group, "DHGroup24")
    ike_encryption = try(var.vng_connection_settings.ipsec_policy[0].ike_encryption, "AES256")
    ike_integrity = try(var.vng_connection_settings.ipsec_policy[0].ike_integrity, "SHA256")
    ipsec_encryption = try(var.vng_connection_settings.ipsec_policy[0].ipsec_encryption, "AES256")
    ipsec_integrity = try(var.vng_connection_settings.ipsec_policy[0].ipsec_integrity, "SHA256")
    pfs_group = try(var.vng_connection_settings.ipsec_policy[0].pfs_group, "None")
    sa_lifetime = try(var.vng_connection_settings.ipsec_policy[0].sa_lifetime, "28800")
  }
}