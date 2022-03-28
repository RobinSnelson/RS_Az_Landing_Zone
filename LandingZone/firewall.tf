resource "azurerm_public_ip" "az_firewall_pip" {
  name                = "${var.project_name}-${var.location_prefix}-net-fw-pip"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_firewall" "az_hub_firewall" {
  name                = "${var.project_name}-${var.location_prefix}-net-fw"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "ip_configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.az_firewall_pip.id
  }

}

resource "azurerm_route_table" "hub_route_table" {
  name                          = "${var.project_name}-${var.location_prefix}-net-fw-rtetbl"
  location                      = azurerm_resource_group.net_rg.location
  resource_group_name           = azurerm_resource_group.net_rg.name
  disable_bgp_route_propagation = false
}