output "firewall_private_ip" {
  description = "The internal IP of the Azure Firewall for routing"
  value       = azurerm_firewall.az-firewall.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  description = "The public IP for external connectivity"
  value       = azurerm_public_ip.pub-ip.ip_address
}