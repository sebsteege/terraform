output "vm_private_ip" {
  description = "The private IP address of the Linux VM"
  value       = { for k, v in azurerm_linux_virtual_machine.linux-vm : k => v.private_ip_address }
}

output "vm_public_ip" {
  description = "The public IP address of the Linux VM"
  value       = { for k, v in azurerm_linux_virtual_machine.linux-vm : k => v.public_ip_address }
}