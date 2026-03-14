output "all_linux_pips" {
  value = {
    "linux-vm-1" = azurerm_public_ip.linux-1-pub-ip.ip_address
    "linux-vm-2" = azurerm_public_ip.linux-2-pub-ip.ip_address
    "linux-vm-3" = azurerm_public_ip.linux-3-pub-ip.ip_address
    "linux-vm-4" = azurerm_public_ip.linux-4-pub-ip.ip_address
    "linux-vm-5" = azurerm_public_ip.linux-5-pub-ip.ip_address
  }
}