data "azurerm_public_ip" "isp-public-ip" {
  name                = "isp-public-ip"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  depends_on = [
    azurerm_linux_virtual_machine.ISP
  ]
}
output "isp-public-ip" {
  value = data.azurerm_public_ip.isp-public-ip.ip_address
}
data "azurerm_public_ip" "rtr-l-public-ip" {
  name                = "rtr-l-public-ip"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  depends_on = [
    azurerm_linux_virtual_machine.RTR-L
  ]
}
output "rtr-l-public-ip" {
  value = data.azurerm_public_ip.rtr-l-public-ip.ip_address
}

data "azurerm_public_ip" "rtr-r-public-ip" {
  name                = "rtr-r-public-ip"
  resource_group_name = data.azurerm_resource_group.RGKP11.name
  depends_on = [
    azurerm_linux_virtual_machine.RTR-R
  ]
}
output "rtr-r-public-ip" {
  value = data.azurerm_public_ip.rtr-r-public-ip.ip_address
}
