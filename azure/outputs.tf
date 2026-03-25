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

output "subnets" {
  description = "Subnets"
  value       = module.azure_networking.subnets
}

output "vm_private_ip" {
  description = "The private IP address of the Linux VM"
  value       = module.azure_linux.vm_private_ip
}

output "vm_public_ip" {
  description = "The public IP address of the Linux VM"
  value       = module.azure_linux.vm_public_ip
}