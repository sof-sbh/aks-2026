# ============================================================
# Key Vault Bootstrap
# RG dédié, séparé du tfstate
# ============================================================

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "bootstrap" {
  name                       = var.keyvault_name
  location                   = azurerm_resource_group.keyvault.location
  resource_group_name        = azurerm_resource_group.keyvault.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
  }

  tags = {
    environment = "bootstrap"
    managed_by  = "terraform"
    project     = "sbh-aks-platform"
  }
}
