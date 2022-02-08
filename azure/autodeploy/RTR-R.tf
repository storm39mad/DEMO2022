###Create RTR-R
resource "azurerm_public_ip" "rtr-r-public-ip" {
  name                = "rtr-r-public-ip"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  location            = data.azurerm_resource_group.RGKP11.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "int-rtrr-inet" {
  name                 = "int-rtrr-inet"
  location             = data.azurerm_resource_group.RGKP11.location
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  enable_ip_forwarding = "true"

  ip_configuration {
    name                          = "inet"
    subnet_id                     = azurerm_subnet.vNET-Subnet-Right-Inet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.1.5"
    public_ip_address_id          = azurerm_public_ip.rtr-r-public-ip.id

  }
}

###
resource "azurerm_network_interface" "int-rtrr-private" {
  name                 = "int-rtrr-private"
  location             = data.azurerm_resource_group.RGKP11.location
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  enable_ip_forwarding = "true"

  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.vNET-Subnet-Private-Right.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.2.5"

  }
}
###
resource "azurerm_linux_virtual_machine" "RTR-R" {
  name                            = "RTR-R"
  resource_group_name             = data.azurerm_resource_group.RGKP11.name
  location                        = data.azurerm_resource_group.RGKP11.location
  size                            = var.sizesmallVM
  disable_password_authentication = "false"
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword

  network_interface_ids = [
    azurerm_network_interface.int-rtrr-inet.id,
    azurerm_network_interface.int-rtrr-private.id
  ]

  os_disk {
    caching              = "None"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    publisher = "debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }
}
