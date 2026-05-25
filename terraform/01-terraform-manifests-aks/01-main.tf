# 1. Terraform Settings Block
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-aks-storage-rg"
    storage_account_name = "terraformstatesbh2028"
    container_name       = "tfstatefiles"
    key                  = "dev.terraform.tfstate"
  }
}

# 2. Provider AzureRM
provider "azurerm" {
  subscription_id = "a3dc9ad0-caa8-484f-83de-5491202f5473"
  features {}
}

# 3. Random Pet
resource "random_pet" "aksrandom" {}