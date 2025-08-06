# Main Terraform configuration for deploying resources in Azure

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
    container_name       = "projectdemeterstate"
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

locals {
  base_name = "ProjectDemeter"
}

# Resource Group Module
module "resource_group" {
  source    = "../../../modules/resource_group"
  base_name = local.base_name
  location  = var.location
  tags      = var.tags
}

# Application Insights Module
module "app_insights" {
  source              = "../../../modules/app_insights"
  appinsight1         = var.appinsight1
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  tags                = var.tags
}

# Virtual Network Data Source
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group
}

# Subnet Data Source
data "azurerm_subnet" "subnet" {
  name                 = var.app_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

# App Service Module
module "app_service_linux" {
  source                = "../../../modules/app_service_linux"
  app_service_plan_name = var.app_service_plan_name
  resource_group_name   = module.resource_group.resource_group_name
  location              = module.resource_group.resource_group_location
  app1_name             = var.app1_name
  vnet_subnet_id     = data.azurerm_subnet.subnet.id
  tags               = var.tags

}