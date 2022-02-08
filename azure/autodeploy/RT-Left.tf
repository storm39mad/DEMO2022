resource "azurerm_route_table" "RT-Left" {
  name                          = "RT-Left"
  location                      = data.azurerm_resource_group.RGKP11.location
  resource_group_name           = data.azurerm_resource_group.RGKP11.name
  disable_bgp_route_propagation = true


  route {
    name                   = "Route-Left"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.5"
  }

}

resource "azurerm_subnet_route_table_association" "Route-Left" {
  subnet_id      = azurerm_subnet.vNET-Subnet-Private-Left.id
  route_table_id = azurerm_route_table.RT-Left.id
}