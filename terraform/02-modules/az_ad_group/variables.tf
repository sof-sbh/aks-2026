# ---------------------------------------------------------------
# 1. GROUP SETTINGS
# ---------------------------------------------------------------

variable "group_name" {
  description = "Nom du groupe Azure AD"
  type        = string

  validation {
    condition     = length(var.group_name) >= 3 && length(var.group_name) <= 120
    error_message = "Le nom du groupe doit faire entre 3 et 120 caractères."
  }
}

variable "description" {
  description = "Description du groupe Azure AD"
  type        = string
  default     = ""
}