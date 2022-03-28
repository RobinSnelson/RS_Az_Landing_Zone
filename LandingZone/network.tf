#Hub Vnet
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.project_name}-${var.location_prefix}-net-vnet"
  resource_group_name = azurerm_resource_group.net_rg.name
  location            = azurerm_resource_group.net_rg.location
  address_space       = ["10.0.240.0/20"]

}

#VPN Gateway Subnet
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.0/27"
  ]

}

#Firewall Subnet
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.128/26"
  ]

}

#Bastion Host Subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.64/26"
  ]

}

##Domain Controllers subnet
resource "azurerm_subnet" "dc_subnet" {
  name                 = "${var.project_name}-${var.location_prefix}-net-dc-sn"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.192/28"
  ]

}

#Management Tools Subnet
resource "azurerm_subnet" "mgmt_tools_subnet" {
  name                 = "${var.project_name}-${var.location_prefix}-net-mgmttools-sn"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.208/28"
  ]

}

#Managemnent Subnet
resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "${var.project_name}-${var.location_prefix}-net-mgmt-sn"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name

  address_prefixes = [
    "10.0.240.32/27"
  ]

  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true

}