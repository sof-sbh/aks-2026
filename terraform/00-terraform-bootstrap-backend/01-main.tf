# ============================================================
# Bootstrap — Backend Terraform + Key Vault
# ============================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "a3dc9ad0-caa8-484f-83de-5491202f5473"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# ---------------------------------------------------------------
# RG 1 — Terraform State
# ---------------------------------------------------------------
resource "azurerm_resource_group" "tfstate" {
  name     = var.tfstate_resource_group_name
  location = var.location
}

# ---------------------------------------------------------------
# RG 2 — Key Vault
# ---------------------------------------------------------------
resource "azurerm_resource_group" "keyvault" {
  name     = var.keyvault_resource_group_name
  location = var.location
}

# ---------------------------------------------------------------
# Storage Account — tfstate
# ---------------------------------------------------------------
resource "azurerm_storage_account" "tfstate" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}
