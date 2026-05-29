# ============================================================
# Module az_acr — Variables
# ============================================================

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "acr_name" {
  description = "Nom du Container Registry (unique globalement, alphanumérique uniquement, 5-50 chars)"
  type        = string
}

variable "sku" {
  description = "SKU du Container Registry : Basic / Standard / Premium"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU doit être Basic, Standard ou Premium."
  }
}

variable "admin_enabled" {
  description = "Activer le compte admin ACR (non recommandé en prod)"
  type        = bool
  default     = false
}

variable "aks_kubelet_object_id" {
  description = "Object ID de la Managed Identity kubelet du cluster AKS"
  type        = string
}

variable "tags" {
  description = "Tags Azure"
  type        = map(string)
  default     = {}
}
