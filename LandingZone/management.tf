#Hub Automation account
resource "azurerm_automation_account" "hub_automation_account" {
  name                = "${var.project_name}-${var.location_prefix}-net-hubaa-aa"
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  location            = azurerm_resource_group.mgmt_rg.location

  sku_name = "Basic"

}

# resource "azurerm_private_link_service" "hub_aa_link_service" {

#   name                = "${var.project_name}-${var.location_prefix}-net-hubaa-plsc"
#   location            = azurerm_resource_group.net_rg.location
#   resource_group_name = azurerm_resource_group.net_rg.name

#   nat_ip_configuration {
#     name      = "pend_ipconfig"
#     subnet_id = azurerm_subnet.mgmt_subnet.id
#     primary = true
#   }

# }

resource "azurerm_private_endpoint" "Automation_Endpoint" {
  name                = "${var.project_name}-${var.location_prefix}-net-hubaa-pvend"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  subnet_id           = azurerm_subnet.mgmt_subnet.id

  private_service_connection {
    name                           = "hubaaendpointconnection"
    private_connection_resource_id = azurerm_private_endpoint.Automation_Endpoint.id
    is_manual_connection           = false

  }

}