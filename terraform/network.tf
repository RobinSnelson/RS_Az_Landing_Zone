resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.project_name}-${var.location_prefix}-net-vnet"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  address_space       = ["10.0.240.0/20"]

}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.0/27"
  ]

}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.128/26"
  ]

}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.64/26"
  ]

}

resource "azurerm_subnet" "dc_subnet" {
  name                 = "${var.project_name}-${var.location_prefix}-net-dc-sn"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.192/28"
  ]
}

resource "azurerm_subnet" "mgmt_tools_subnet" {
  name                 = "${var.project_name}-${var.location_prefix}-net-mgmt-sn"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.208/28"
  ]
}