###Create RTR-L
resource "azurerm_public_ip" "rtr-l-public-ip" {
  name                = "rtr-l-public-ip"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  location            = data.azurerm_resource_group.RGKP11.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "int-rtrl-inet" {
  name                 = "int-rtrl-inet"
  location             = data.azurerm_resource_group.RGKP11.location
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  enable_ip_forwarding = "true"

  ip_configuration {
    name                          = "inet"
    subnet_id                     = azurerm_subnet.vNET-Subnet-Left-Inet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.rtr-l-public-ip.id

  }
}

###
resource "azurerm_network_interface" "int-rtrl-private" {
  name                 = "int-rtrl-private"
  location             = data.azurerm_resource_group.RGKP11.location
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  enable_ip_forwarding = "true"

  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.vNET-Subnet-Private-Left.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.5"

  }
}
###
resource "azurerm_linux_virtual_machine" "RTR-L" {
  name                            = "RTR-L"
  resource_group_name             = data.azurerm_resource_group.RGKP11.name
  location                        = data.azurerm_resource_group.RGKP11.location
  size                            = var.sizesmallVM
  disable_password_authentication = "false"
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword

  network_interface_ids = [
    azurerm_network_interface.int-rtrl-inet.id,
    azurerm_network_interface.int-rtrl-private.id
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
