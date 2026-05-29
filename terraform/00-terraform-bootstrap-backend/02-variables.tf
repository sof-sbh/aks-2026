# ============================================================
# Variables Bootstrap
# ============================================================

variable "location" {
  type        = string
  description = "Région Azure"
  default     = "westeurope"
}

# ---------------------------------------------------------------
# Terraform State
# ---------------------------------------------------------------
variable "tfstate_resource_group_name" {
  type        = string
  description = "RG pour le Terraform state"
  default     = "rg-tfstate-bootstrap-weu"
}

variable "storage_account_name" {
  type        = string
  description = "Nom du Storage Account pour le tfstate"
  default     = "terraformstatesbh2031"
}

variable "storage_container_name" {
  type        = string
  description = "Nom du container blob pour le tfstate"
  default     = "tfstatefiles"
}

# ---------------------------------------------------------------
# Key Vault
# ---------------------------------------------------------------
variable "keyvault_resource_group_name" {
  type        = string
  description = "RG dédié au Key Vault bootstrap"
  default     = "rg-keyvault-bootstrap-weu"
}

variable "keyvault_name" {
  type        = string
  description = "Nom du Key Vault (unique globalement, 3-24 chars)"
  default     = "sbh-aks-kv-bootstrap"
}

# ---------------------------------------------------------------
# Secrets — passés via TF_VAR_, jamais en clair
# ---------------------------------------------------------------
variable "windows_admin_password" {
  type        = string
  description = "Mot de passe admin Windows AKS"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "Clé SSH publique pour les nodes Linux AKS"
  sensitive   = true
}
