# database.tf
resource "azurerm_sql_server" "sql_server" {
  name                         = "sqlserver${random_integer.server_suffix.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = azurerm_key_vault_secret.sql_admin_password.value

  # Allow Azure services to access the server
  public_network_access_enabled = true
}

resource "random_integer" "server_suffix" {
  min = 10000
  max = 99999
}

resource "azurerm_sql_database" "sql_db" {
  name                = "mydatabase"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sql_server.name
  sku_name            = "S0"
}
