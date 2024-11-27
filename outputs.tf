# outputs.tf
output "web_lb_public_ip" {
  description = "Public IP address of the Load Balancer"
  value       = azurerm_public_ip.lb_public_ip.ip_address
}

output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_public_ip.ip_address
}

output "sql_server_name" {
  description = "Name of the Azure SQL Server"
  value       = azurerm_sql_server.sql_server.name
}

output "sql_database_name" {
  description = "Name of the Azure SQL Database"
  value       = azurerm_sql_database.sql_db.name
}
