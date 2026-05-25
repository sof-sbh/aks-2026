variable "location" {
  description = "Région Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group cible"
  type        = string
}

variable "retention_in_days" {
  description = "Rétention des logs en jours (min 30, max 730)"
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "La rétention doit être entre 30 et 730 jours."
  }
}

variable "tags" {
  description = "Tags à appliquer sur le workspace"
  type        = map(string)
  default     = {}
}