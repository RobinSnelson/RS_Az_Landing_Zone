resource "azurerm_resource_group" "net_rg" {
  name     = "${var.project_name}-${var.location_prefix}-net-rg"
  location = var.default_location
}

resource "azurerm_resource_group" "mgmt_rg" {
  name     = "${var.project_name}-${var.location_prefix}-mgmt-rg"
  location = var.default_location

}

