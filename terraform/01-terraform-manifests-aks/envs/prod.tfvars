# ============================================================
# prod.tfvars — Environnement PROD
# ============================================================

# --- Général ---
location            = "westeurope"
resource_group_name = "rg-aks"
environment         = "prod"

# --- AKS ---
ssh_public_key         = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
windows_admin_username = "azureuser"

# --- ACR ---
acr_name = "sbhaksprod"
acr_sku  = "Premium"

# --- Tags ---
tags = {
  Environment = "prod"
  ManagedBy   = "terraform"
  Project     = "sbh-aks-platform"
}
