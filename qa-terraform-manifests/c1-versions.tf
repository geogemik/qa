# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 1.0"
    }
  }
  # Terraform State Storage to Azure Storage Container (Values will be taken from Azure DevOps)
  backend "azurerm" {
    resource_group_name  = "terraformstorage"
    storage_account_name = "terraformstgedemoiacqa"
    container_name       = "terrastate"
    key                  = "qa.terraform.tfstate"
  }
}

# Provider Block
provider "azurerm" {
  features {}
  subscription_id = "d2b83b21-b63f-4c16-a9c4-ee3d9553e497"
  client_id       = "be026083-3982-43ca-a2f5-0bf66f24d011"
  client_secret   = "iKG8Q~5ObS53eOUta54uDPUu_5fxRJfiE8x-ebl9"
  tenant_id       = "bbb8e3ab-7408-4c6f-a4ab-d87cf9ed5fc8"
}



