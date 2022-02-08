###Create ISP
resource "azurerm_public_ip" "isp-public-ip" {
  name                = "isp-public-ip"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  location            = data.azurerm_resource_group.RGKP11.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "int-ips-inet" {
  name                = "int-isp-inet"
  location            = data.azurerm_resource_group.RGKP11.location
  resource_group_name = data.azurerm_resource_group.RGKP11.name


  ip_configuration {
    name                          = "inet"
    subnet_id                     = azurerm_subnet.vNET-Subnet-ISP-Inet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.5"
    public_ip_address_id          = azurerm_public_ip.isp-public-ip.id
  }
}

resource "azurerm_linux_virtual_machine" "ISP" {
  name                            = "ISP"
  resource_group_name             = data.azurerm_resource_group.RGKP11.name
  location                        = data.azurerm_resource_group.RGKP11.location
  size                            = var.sizesmallVM
  disable_password_authentication = "false"
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword

  network_interface_ids = [
    azurerm_network_interface.int-ips-inet.id,
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
