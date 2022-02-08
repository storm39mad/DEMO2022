###Create WEB-R

###
resource "azurerm_network_interface" "int-webr-private" {
  name                = "int-webr-private"
  location            = "West Europe"
  resource_group_name = data.azurerm_resource_group.RGKP11.name


  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.vNET-Subnet-Private-Right.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.2.6"
  }
}
###
resource "azurerm_linux_virtual_machine" "WEB-R" {
  name                            = "WEB-R"
  resource_group_name             = data.azurerm_resource_group.RGKP11.name
  location                        = "West Europe"
  size                            = "Standard_B2s"
  disable_password_authentication = "false"
  admin_username                  = "WEBRAdmin"
  admin_password                  = "Pa$$w0rdPa$$w0rd"

  network_interface_ids = [
    azurerm_network_interface.int-webr-private.id,
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