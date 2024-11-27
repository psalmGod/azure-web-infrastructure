# provider.tf
provider "azurerm" {
  features {}
}

provider "random" {
  # Used for generating random passwords
}
