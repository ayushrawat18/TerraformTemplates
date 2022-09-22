variable "azure_subscription_id" {}

variable "azure_client_id" {}

variable "azure_client_secret" {}

variable "azure_tenant_id" {}

variable "azure_rgname" {}

variable "servername" {}

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.azure_rgname
  location = "westus"
}

resource "azurerm_mysql_server" "example" {
  name                = var.servername
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}
