resource "azurerm_public_ip" "linux-1-pub-ip" {
  name = "linux-1-pub-ip"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
}

resource "azurerm_network_interface" "linux1-vm-nic" {
  name                = "linux1-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1_subnet_a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux-1-pub-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_interface_lvm1" {
  network_interface_id      = azurerm_network_interface.linux1-vm-nic.id
  network_security_group_id = azurerm_network_security_group.allow_ssh_in.id
}

resource "azurerm_linux_virtual_machine" "linux1-vm" {
  name                = "linux1-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "cvadmin"
  network_interface_ids = [
    azurerm_network_interface.linux1-vm-nic.id,
  ]

  admin_ssh_key {
    username   = "cvadmin"
    public_key = file("~/.ssh/cvdesktop_rsa.pub")
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
  custom_data = data.cloudinit_config.apache.rendered
}