# variables.tf
variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "web-infrastructure-rg"
}

variable "location" {
  description = "Azure region to deploy resources"
  default     = "eastus"
}

variable "admin_username" {
  description = "Admin username for VMs"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
}

variable "sql_admin_username" {
  description = "Admin username for SQL Server"
  default     = "sqladminuser"
}

variable "sql_admin_password" {
  description = "Admin password for SQL Server"
  type        = string
}
