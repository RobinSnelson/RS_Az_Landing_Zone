resource "azurerm_network_security_group" "az_dc_nsg" {
  name                = "${var.project_name}-${var.location_prefix}-net-nsg-dc"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "ad_ports"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "dc_servers_nic" {
  name                = "${var.project_name}-${var.location_prefix}-net-nic-dc-${format("%02d", count.index + 1)}-nic"
  location            = azurerm_resource_group.mgmt_rg.location
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  count               = var.dc_count

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.dc_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "dc_vm" {
  name                     = "${var.project_name}-${var.location_prefix}-dc${format("%02d", count.index + 1)}-vm"
  resource_group_name      = azurerm_resource_group.mgmt_rg.name
  location                 = azurerm_resource_group.mgmt_rg.location
  size                     = "Standard_B2s"
  admin_username           = "sysadmin"
  admin_password           = var.admin_password
  count                    = var.dc_count
  provision_vm_agent       = true
  enable_automatic_updates = true

  network_interface_ids = [
    azurerm_network_interface.dc_servers_nic[count.index].id
  ]

  os_disk {
    name                 = "${var.project_name}-${var.location_prefix}-dc${format("%02d", count.index + 1)}-vm-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}