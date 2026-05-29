# ============================================================
# 04 — Secrets initiaux dans Key Vault
# Valeurs injectées via TF_VAR_ — jamais en clair dans le code
# ============================================================

resource "azurerm_key_vault_secret" "windows_admin_password" {
  name         = "aks-windows-admin-password"
  value        = var.windows_admin_password
  key_vault_id = azurerm_key_vault.bootstrap.id

  tags = {
    managed_by = "terraform"
  }
}

resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "aks-ssh-public-key"
  value        = var.ssh_public_key
  key_vault_id = azurerm_key_vault.bootstrap.id

  tags = {
    managed_by = "terraform"
  }
}
