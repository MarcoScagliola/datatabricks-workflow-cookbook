# Define provider
provider "azurerm" {
  features {}
}

# Load variables from terraform.tfvars file
terraform {
  required_version = ">= 1.8.2"
}

# Define variables
variable "resource_group_name" {}
variable "location" {}
variable "db_workspace_name" {}
variable "db_workspace_name_sku" {}
variable "adls_gen2_account_name" {}
variable "storage_account_tier" {}

# Load variables from terraform.tfvars file
terraform {
  required_version = ">= 1.8.2"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

# Create resource group
resource "azurerm_resource_group" "rg_dbworkflows" {
  name     = var.resource_group_name
  location = var.location
}

# Create Databricks workspace
resource "azurerm_databricks_workspace" "example" {
  name                    = var.db_workspace_name
  resource_group_name     = azurerm_resource_group.rg_dbworkflows.name
  location                = azurerm_resource_group.rg_dbworkflows.location
  sku                     = var.db_workspace_name_sku
   tags = {
    Environment = "Development"
  }
}

# Create ADLS Gen2 account
resource "azurerm_storage_account" "example" {
  name                     = var.adls_gen2_account_name
  resource_group_name      = azurerm_resource_group.rg_dbworkflows.name
  location                 = azurerm_resource_group.rg_dbworkflows.location
  account_tier             = var.storage_account_tier
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "example-container"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}
