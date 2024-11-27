# security.tf
resource "azurerm_security_center_contact" "contact" {
  email               = "youremail@example.com"
  phone               = "1234567890"
  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_security_center_subscription_pricing" "standard_pricing" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "sql_servers_pricing" {
  tier          = "Standard"
  resource_type = "SqlServers"
}
