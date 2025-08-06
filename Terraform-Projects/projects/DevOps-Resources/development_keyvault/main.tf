terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "TerraformRG"
    storage_account_name = "terraformsa1203"
    container_name       = "devops-resources"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "example" {
  name = var.resource_group_name
}

module "keyvault" {
  source              = "../../../modules/keyvault"
  keyvault_name       = var.keyvault_name
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  secret_name         = "example-secret-name"  # Replace with actual secret name
  secret_value        = "example-secret-value" # Replace with actual secret value
}