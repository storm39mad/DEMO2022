###Create ISP

resource "azurerm_network_interface" "int-srv-private" {
  name                = "int-srv-private"
  location            = data.azurerm_resource_group.RGKP11.location
  resource_group_name = data.azurerm_resource_group.RGKP11.name


  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.vNET-Subnet-Private-Left.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.7"
  }
}

resource "azurerm_managed_disk" "srv-disk-1" {
  name                 = "srv-disk-1"
  location             = data.azurerm_resource_group.RGKP11.location
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "5"
}

resource "azurerm_managed_disk" "srv-disk-2" {
  name                 = "srv-disk-2"
  location             = data.azurerm_resource_group.RGKP11.location
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "5"
}

resource "azurerm_windows_virtual_machine" "SRV" {
  name                = "SRV"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  location            = data.azurerm_resource_group.RGKP11.location
  size                = var.sizeVM
  admin_username      = var.adminusername
  admin_password      = var.adminpassword

  network_interface_ids = [
    azurerm_network_interface.int-srv-private.id,
  ]

  os_disk {
    caching              = "None"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "atta-srv-disk-1" {
  managed_disk_id    = azurerm_managed_disk.srv-disk-1.id
  virtual_machine_id = azurerm_windows_virtual_machine.SRV.id
  lun                = "10"
  caching            = "None"
}
resource "azurerm_virtual_machine_data_disk_attachment" "atta-srv-disk-2" {
  managed_disk_id    = azurerm_managed_disk.srv-disk-2.id
  virtual_machine_id = azurerm_windows_virtual_machine.SRV.id
  lun                = "11"
  caching            = "None"
}