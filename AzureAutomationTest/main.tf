#Resource Group
resource "azurerm_resource_group" "aac_rg" {
  name     = "AzureAutomationTest-RG"
  location = "WestEurope"
}

#Hub Vnet
resource "azurerm_virtual_network" "aac_vnet" {
  name                = "aac-vnet"
  resource_group_name = azurerm_resource_group.aac_rg.name
  location            = azurerm_resource_group.aac_rg.location
  address_space       = ["10.0.0.0/22"]
}

#VPN Gateway Subnet
resource "azurerm_subnet" "aac_subnet" {
  name                 = "aac-sn"
  resource_group_name  = azurerm_resource_group.aac_rg.name
  virtual_network_name = azurerm_virtual_network.aac_vnet.name

  address_prefixes = [
    "10.0.1.0/24"
  ]

  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

#Automation Account
resource "azurerm_automation_account" "aac_automation_account" {
  name                = "aac-aa"
  resource_group_name = azurerm_resource_group.aac_rg.name
  location            = azurerm_resource_group.aac_rg.location

  sku_name = "Basic"

}

#Private Endpoint
resource "azurerm_private_endpoint" "Automation_Endpoint" {
  name                = "aac-pvend"
  location            = azurerm_resource_group.aac_rg.location
  resource_group_name = azurerm_resource_group.aac_rg.name
  subnet_id           = azurerm_subnet.aac_subnet.id
  depends_on = [
    azurerm_subnet.aac_subnet
  ]

  private_service_connection {
    name                           = "hubaaendpointconnection"
    private_connection_resource_id = azurerm_automation_account.aac_automation_account.id
    is_manual_connection           = false
    subresource_names = [
      "Webhook"
    ]

  }

}