# main.tf
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.resource_group_name}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get",
      "set",
      "delete",
      "list",
      "purge",
      "recover",
      "backup",
      "restore",
    ]
  }
}

# Store admin passwords in Key Vault
resource "random_password" "vm_admin_password" {
  length  = 16
  special = true
}

resource "random_password" "sql_admin_password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  value        = random_password.vm_admin_password.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin_password.result
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_client_config" "current" {}
