# ---------------------------------------------------------------
# 1. BASIC CLUSTER SETTINGS
# ---------------------------------------------------------------

variable "name" {
  description = "Nom du cluster AKS"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group où déployer l'AKS"
  type        = string
}

variable "dns_prefix" {
  description = "Préfixe DNS du cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Version Kubernetes (ex: récupérée via data.azurerm_kubernetes_service_versions.current.latest_version)"
  type        = string
}

variable "node_resource_group" {
  description = "Nom du Resource Group créé pour les ressources des noeuds (VMs, disques, NICs)"
  type        = string
}

# ---------------------------------------------------------------
# 2. DEFAULT NODE POOL
# ---------------------------------------------------------------

variable "node_pool_name" {
  description = "Nom du default node pool"
  type        = string
  default     = "systempool"
}

variable "vm_size" {
  description = "Taille des VMs du node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "availability_zones" {
  description = "Zones de disponibilité pour le default node pool"
  type        = list(number)
  default     = [3]
}

variable "auto_scaling_enabled" {
  description = "Activer l'autoscaling sur le default node pool"
  type        = bool
  default     = true
}

variable "max_count" {
  description = "Nombre maximum de noeuds (autoscaling)"
  type        = number
  default     = 3
}

variable "min_count" {
  description = "Nombre minimum de noeuds (autoscaling)"
  type        = number
  default     = 1
}

variable "os_disk_size_gb" {
  description = "Taille du disque OS des noeuds (Go)"
  type        = number
  default     = 30
}

variable "node_labels" {
  description = "Labels Kubernetes appliqués aux noeuds du pool"
  type        = map(string)
  default = {
    "nodepool-type" = "system"
    "environment"   = ""
    "nodepoolos"    = "linux"
    "app"           = "system-apps"
  }
}

variable "node_pool_tags" {
  description = "Tags appliqués aux noeuds du pool"
  type        = map(string)
  default = {
    "nodepool-type" = "system"
    "environment"   = ""
    "nodepoolos"    = "linux"
    "app"           = "system-apps"
  }
}


# ---------------------------------------------------------------
# 3. Vnet
# --------------------------------------------------------------- 

variable "vnet_subnet_id" {
  description = "ID du subnet pour le default node pool"
  type        = string
  default     = null
}


# ---------------------------------------------------------------
# 4. ADD-ON PROFILES
# ---------------------------------------------------------------

variable "log_analytics_workspace_id" {
  description = "ID du Log Analytics Workspace pour l'OMS Agent (Azure Monitor)"
  type        = string
}

# ---------------------------------------------------------------
# 5. RBAC & AZURE AD INTEGRATION
# ---------------------------------------------------------------

variable "admin_group_object_ids" {
  description = "Liste des object IDs des groupes Azure AD ayant les droits admin sur le cluster"
  type        = list(string)
}

# ---------------------------------------------------------------
# 6. ADMIN PROFILES
# ---------------------------------------------------------------

variable "windows_admin_username" {
  description = "Nom d'utilisateur admin pour les noeuds Windows"
  type        = string
}

variable "windows_admin_password" {
  description = "Mot de passe admin pour les noeuds Windows"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Chemin vers la clé SSH publique pour l'accès aux noeuds Linux (ex: ~/.ssh/id_rsa.pub)"
  type        = string
}

variable "linux_admin_username" {
  description = "Nom d'utilisateur admin pour les noeuds Linux"
  type        = string
  default     = "ubuntu"
}

# ---------------------------------------------------------------
# 8. CLUSTER TAGS
# ---------------------------------------------------------------

variable "tags" {
  description = "Tags à appliquer sur le cluster AKS"
  type        = map(string)
  default = {
    Environment = "dev"
  }
}