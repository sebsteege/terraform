# outputs.tf
output "firewall_private_ip" {
  description = "The internal IP of the Azure Firewall for routing"
  value       = azurerm_firewall.az-firewall.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  description = "The public IP for external connectivity"
  value       = azurerm_public_ip.pub-ip.ip_address
}

output "vng_public_ip" {
  description = "Virtual Network Gateway Public IP"
  value       = azurerm_public_ip.vng-pub-ip.ip_address
}

output "ipsec_settings" {
  description = "IPSec Settings"
  value       = azurerm_virtual_network_gateway_connection.azure_to_cvlab.ipsec_policy 
}
