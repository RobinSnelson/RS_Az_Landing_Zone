#Hub Automation account
resource "azurerm_automation_account" "hub_automation_account" {
  name                = "${var.project_name}-${var.location_prefix}-net-hubaa-aa"
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  location            = azurerm_resource_group.mgmt_rg.location

  sku_name = "Basic"

}

#Hub Automation account Private Endpoint
resource "azurerm_private_endpoint" "Automation_Endpoint" {
  name                = "${var.project_name}-${var.location_prefix}-net-hubaa-pvend"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  subnet_id           = azurerm_subnet.mgmt_subnet.id

  private_service_connection {
    name                           = "hubaaendpointconnection"
    private_connection_resource_id = azurerm_automation_account.hub_automation_account.id
    is_manual_connection           = false
    subresource_names = [
      "Webhook"
    ]

  }

}

resource "azurerm_role_assignment" "hub_rsv_roleassign" {
  principal_id       = azurerm_recovery_services_vault.hub_recovery_services_vault.identity.principal_id
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"

  depends_on = [
    azurerm_recovery_services_vault.hub_recovery_services_vault
  ]

}


#Hub Recovery Services Vault
resource "azurerm_recovery_services_vault" "hub_recovery_services_vault" {
  name                = "${var.project_name}-${var.location_prefix}-net-hubrsv-rsv"
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  location            = azurerm_resource_group.mgmt_rg.location
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
  identity {
    type = "SystemAssigned"
  }

  soft_delete_enabled = true
}

resource "azurerm_private_endpoint" "rsv_Endpoint" {
  name                = "${var.project_name}-${var.location_prefix}-net-hubrsv-pvend"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  subnet_id           = azurerm_subnet.mgmt_subnet.id

  depends_on = [
    azurerm_role_assignment.hub_rsv_roleassign
  ]
  private_service_connection {
    name                           = "hubrsvendpointconnection"
    private_connection_resource_id = azurerm_recovery_services_vault.hub_recovery_services_vault.id
    is_manual_connection           = false
    subresource_names = [
      "AzureBackup" #
      ##this can be "AzureBackup" or "AzureSiteRecovery"
    ]



  }

}

