resource "azurerm_public_ip" "az_bastion_pip" {
  name                = "${var.project_name}-${var.location_prefix}-net-bast-pip"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_bastion_host" "az_hub_bastion" {
  name                = "${var.project_name}-${var.location_prefix}-net-hubbast"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name

  ip_configuration {
    name                 = "ip_config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.az_bastion_pip.id
  }

}