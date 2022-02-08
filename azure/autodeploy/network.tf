

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vNET-LEFT" {
  name                = "vNET-LEFT"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  location            = data.azurerm_resource_group.RGKP11.location
  address_space       = ["10.0.0.0/16"]
}
# Create a virtual subnet 1
resource "azurerm_subnet" "vNET-Subnet-Left-Inet" {
  name                 = "vNET-Subnet-Left-Inet"
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  virtual_network_name = azurerm_virtual_network.vNET-LEFT.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create a virtual subnet 2
resource "azurerm_subnet" "vNET-Subnet-Private-Left" {
  name                 = "vNET-Subnet-Private-Left"
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  virtual_network_name = azurerm_virtual_network.vNET-LEFT.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vNET-RIGHT" {
  name                = "vNET-RIGHT"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  location            = data.azurerm_resource_group.RGKP11.location
  address_space       = ["172.16.0.0/16"]
}

# Create a virtual subnet 1
resource "azurerm_subnet" "vNET-Subnet-Right-Inet" {
  name                 = "vNET-Subnet-Right-Inet"
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  virtual_network_name = azurerm_virtual_network.vNET-RIGHT.name
  address_prefixes     = ["172.16.1.0/24"]
}

# Create a virtual subnet 2
resource "azurerm_subnet" "vNET-Subnet-Private-Right" {
  name                 = "vNET-Subnet-Private-Right"
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  virtual_network_name = azurerm_virtual_network.vNET-RIGHT.name
  address_prefixes     = ["172.16.2.0/24"]
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vNET-INET" {
  name                = "vNET-INET"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  location            = data.azurerm_resource_group.RGKP11.location
  address_space       = ["192.168.0.0/16"]
}

# Create a virtual subnet 1
resource "azurerm_subnet" "vNET-Subnet-ISP-Inet" {
  name                 = "vNET-Subnet-ISP-Inet"
  resource_group_name  = data.azurerm_resource_group.RGKP11.name
  virtual_network_name = azurerm_virtual_network.vNET-INET.name
  address_prefixes     = ["192.168.1.0/24"]
}
