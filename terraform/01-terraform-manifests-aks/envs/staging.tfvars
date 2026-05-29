# ============================================================
# staging.tfvars — Environnement STAGING
# ============================================================

# --- Général ---
location            = "westeurope"
resource_group_name = "rg-aks"
environment         = "staging"

# --- AKS ---
ssh_public_key         = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
windows_admin_username = "azureuser"

# --- ACR ---
acr_name = "sbhaksstaging"
acr_sku  = "Standard"

# --- Tags ---
tags = {
  Environment = "staging"
  ManagedBy   = "terraform"
  Project     = "sbh-aks-platform"
}