# compute.tf
# Availability Set for Web Tier VMs
resource "azurerm_availability_set" "web_avset" {
  name                = "web-tier-avset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
}

# Network Interfaces for Web VMs
resource "azurerm_network_interface" "web_nic" {
  count               = 2
  name                = "web-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-ip-config"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Web Tier VMs
resource "azurerm_windows_virtual_machine" "web_vm" {
  count               = 2
  name                = "web-vm-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_D2s_v3"
  availability_set_id = azurerm_availability_set.web_avset.id
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.vm_admin_password.value

  network_interface_ids = [
    azurerm_network_interface.web_nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Network Interface for Database VM
resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "db-ip-config"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Database Tier VM
resource "azurerm_windows_virtual_machine" "db_vm" {
  name                = "db-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_D4s_v3"
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.vm_admin_password.value

  network_interface_ids = [
    azurerm_network_interface.db_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 256
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
