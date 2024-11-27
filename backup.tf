# backup.tf
# Recovery Services Vault
resource "azurerm_recovery_services_vault" "backup_vault" {
  name                = "backup-vault"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

# Backup Policy for VMs
resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  name                = "vm-backup-policy"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}

# Protect VMs with Backup Policy
resource "azurerm_backup_protected_vm" "vm_backup" {
  count               = 3
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name
  source_vm_id        = element(azurerm_windows_virtual_machine.all_vms.*.id, count.index)
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup_policy.id
}

# Combine web and db VMs
resource "azurerm_windows_virtual_machine" "all_vms" {
  count = length(azurerm_windows_virtual_machine.web_vm) + 1

  # This is a placeholder to combine web and db VMs for backup association
  # Use data sources or adjust accordingly
}
