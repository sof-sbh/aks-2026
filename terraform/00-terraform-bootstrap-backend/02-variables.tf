variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "westeurope"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type        = string
  description = "This variable defines the Resource Group"
  default     = "terraform-aks-storage-rg"
}

variable "storage_account_name" {
  type        = string
  description = "This variable defines the Storage account"
  default     = "terraformstatesbh2028"
}

variable "storage_container_name" {
  type        = string
  description = "This variable defines the Storage account"
  default     = "tfstatefiles"
}
