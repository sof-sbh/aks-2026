# ============================================================
# dev.tfvars — Environnement DEV
# ============================================================

# --- Général ---
location            = "westeurope"
resource_group_name = "rg-aks"
environment         = "dev"

# --- AKS ---
ssh_public_key         = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
windows_admin_username = "azureuser"

# --- ACR ---
acr_name = "sbhaksdev"
acr_sku  = "Basic"

# --- Tags ---
tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Project     = "sbh-aks-platform"
}
