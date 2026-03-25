# main.tf
resource "azurerm_public_ip" "vm-pub-ip" {
  for_each = var.linux_vm_configuration
  name = "${each.value.name}-pubip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
}

resource "azurerm_network_interface" "vm-nic" {
  for_each            = var.linux_vm_configuration
  name                = "${each.value.name}-vmnic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.networking_subnet_ids[each.value.subnet]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-pub-ip[each.key].id
  }
}

resource "azurerm_network_security_group" "allow_ssh_in" {
  name                = "allow_ssh_in"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "ssh_interface_nsg" {
  for_each                  = azurerm_network_interface.vm-nic
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.allow_ssh_in.id
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
  for_each            = var.linux_vm_configuration
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  network_interface_ids = [
    azurerm_network_interface.vm-nic[each.key].id,
  ]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file(each.value.key_file)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}