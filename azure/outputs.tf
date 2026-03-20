output "firewall_private_ip" {
  description = "The internal IP of the Azure Firewall for routing"
  value       = module.azure_networking.firewall_private_ip
}

output "firewall_public_ip" {
  description = "The public IP for external connectivity"
  value       = module.azure_networking.firewall_public_ip
}

output "vng_public_ip" {
  description = "The public IP for external connectivity"
  value       = module.azure_networking.vng_public_ip
}

output "ipsec_settings" {
  description = "IPSec Settings"
  value       = module.azure_networking.ipsec_settings
}
