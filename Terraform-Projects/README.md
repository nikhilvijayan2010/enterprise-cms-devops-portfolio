# Azure Infrastructure Deployment with Terraform

This repository contains Terraform configurations for deploying resources in Azure, including a resource group, SQL Server, database within an elastic pool, Application Insights, virtual network, subnet, and an App Service.

## Prerequisites

- Terraform installed
- Azure subscription
- Service principal with sufficient permissions
- Existing SQL Server and elastic pool in Azure

## Configuration

### Terraform Backend

The backend configuration is set to use Azure Storage for storing the Terraform state.

```hcl
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
    container_name       = "rlvaritytoolstate"
    key                  = "terraform.tfstate"
  }
}
Provider Configuration
The Azure provider is configured with the subscription ID and necessary features.

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "6265bce6-d9a1-412b-b2c9-565a7d6880a7"
}
Modules
Resource Group
Creates a resource group for the deployment.

module "resource_group" {
  source    = "../../modules/resource_group"
  base_name = "RLVarietySelectionTool"
  location  = var.location
}
SQL Server and Database
Fetches the existing SQL Server and elastic pool, and creates a database within the elastic pool.

data "azurerm_mssql_server" "existing_sql_server" {
  name                = var.sql_server_name
  resource_group_name = var.sql_server_resource_group
}

data "azurerm_mssql_elasticpool" "existing_elastic_pool" {
  name                = "adbDev01ElasticPool01UKS"
  resource_group_name = var.sql_server_resource_group
  server_name         = var.sql_server_name
}

module "sql_server" {
  source              = "../../modules/sql_server"
  server_id           = data.azurerm_mssql_server.existing_sql_server.id
  resource_group_name = data.azurerm_mssql_server.existing_sql_server.resource_group_name
  location            = data.azurerm_mssql_server.existing_sql_server.location
  database1_name      = var.database1_name
  elastic_pool_id     = data.azurerm_mssql_elasticpool.existing_elastic_pool.id
}
Application Insights
Creates an Application Insights resource.

module "app_insights" {
  source              = "../../modules/app_insights"
  appinsight1         = var.appinsight1
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
}
Virtual Network and Subnet
Fetches the existing virtual network and subnet.

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group
}

data "azurerm_subnet" "subnet" {
  name                = var.app_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
}
App Service
Creates an App Service and configures it to use the SQL Server database and Application Insights.

module "app_service" {
  source                = "../../modules/app_service"
  app_service_plan_name = var.app_service_plan_name
  resource_group_name   = module.resource_group.resource_group_name
  location              = module.resource_group.resource_group_location
  base_name             = var.base_name
  app1_name             = var.app1_name
  sql_server_name       = data.azurerm_mssql_server.existing_sql_server.name
  database1_name        = module.sql_server.sql_database1_name
  app_insights_key_1    = module.app_insights.app1_instrumentation_key
  vnet_subnet_id        = data.azurerm_subnet.subnet.id
}
Variables
Define the necessary variables in variables.tf:

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "sql_server_name" {
  description = "The name of the existing SQL Server"
  type        = string
}

variable "sql_server_resource_group" {
  description = "The resource group of the existing SQL Server"
  type        = string
}

variable "database1_name" {
  description = "The name of the database to be created"
  type        = string
}

variable "appinsight1" {
  description = "The name of the Application Insights resource"
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing virtual network"
  type        = string
}

variable "vnet_resource_group" {
  description = "The resource group of the existing virtual network"
  type        = string
}

variable "app_subnet_name" {
  description = "The name of the subnet within the virtual network"
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service plan"
  type        = string
}

variable "base_name" {
  description = "The base name for resources"
  type        = string
}

variable "app1_name" {
  description = "The name of the App Service"
  type        = string
}
Usage
Initialize Terraform:

terraform init
Plan the deployment:

terraform plan -var-file="terraform.tfvars"
Apply the deployment:

terraform apply -var-file="terraform.tfvars"
Notes
Ensure that the terraform.tfvars file contains the necessary variable values.
Make sure you have the required permissions to create and manage resources in the specified Azure subscription.






# Azure Infrastructure Deployment with Terraform

This repository contains reusable Terraform configurations and Azure DevOps pipelines for deploying and managing Azure infrastructure for multiple projects. It supports modular, environment-specific deployments using best practices for infrastructure-as-code.

## Structure

- **modules/**: Reusable Terraform modules for common Azure resources (App Service, App Insights, Key Vault, SQL Server, Storage Account, VNet, etc.).
- **projects/**: Project-specific infrastructure definitions, each with their own environments (e.g., `dev`, `prod`).
- **azure-pipelines.yml**: Example pipeline for validating and deploying Terraform code via Azure DevOps.
- **azure-pipeline-destroy.yml**: Example pipeline for destroying infrastructure via Azure DevOps.
- **.gitignore**: Ignores Terraform state, sensitive files, and local overrides.

## Key Modules

- [`modules/app_service`](modules/app_service/): Deploys Windows App Services.
- [`modules/app_service_linux`](modules/app_service_linux/): Deploys Linux App Services.
- [`modules/app_insights`](modules/app_insights/): Deploys Application Insights.
- [`modules/keyvault`](modules/keyvault/): Deploys Azure Key Vault and secrets.
- [`modules/sql_server`](modules/sql_server/): Manages SQL Server databases.
- [`modules/storage_account`](modules/storage_account/): Deploys Storage Accounts and containers.
- [`modules/vnet`](modules/vnet/): Deploys Virtual Networks.

## Project Layout

Each project (e.g., `Dairy_Breeding_Genetics`, `RL_Variety_Selection_Tool`, `Project_Demeter`) contains:

- `dev/`, `prod/`: Environment-specific Terraform code and variables.
- `azure-pipelines.yml`: Azure DevOps pipeline for CI/CD.

## Example: RL_Variety_Selection_Tool

- [dev/main.tf](projects/RL_Variety_Selection_Tool/dev/main.tf): Deploys resource group, fetches existing SQL Server, elastic pool, Key Vault secrets, and provisions App Service, App Insights, and VNet integration.
- [dev/variables.tf](projects/RL_Variety_Selection_Tool/dev/variables.tf): Defines all required variables for the environment.
- [dev/azure-pipelines.yml](projects/RL_Variety_Selection_Tool/dev/azure-pipelines.yml): Pipeline for validating, planning, and applying Terraform changes.

## Usage

1. **Initialize Terraform**  
   ```sh
   terraform init
   ```

2. **Plan Deployment**  
   ```sh
   terraform plan -var-file="terraform.tfvars"
   ```

3. **Apply Deployment**  
   ```sh
   terraform apply -var-file="terraform.tfvars"
   ```

4. **CI/CD**  
   Use the provided Azure Pipelines YAML files for automated validation and deployment.

## Prerequisites

- Terraform CLI
- Azure subscription and service principal with required permissions
- Existing shared resources (e.g., SQL Server, elastic pool, VNet) as referenced in variables

## Notes

- Sensitive values (e.g., passwords, secrets) should be stored in Azure Key Vault and referenced via data sources.
- State is stored in Azure Storage Account backends for team collaboration and safety.
- Each environment can be managed independently.

## Contributing

1. Fork and clone the repository.
2. Add or update modules or project environments as needed.
3. Test changes locally with Terraform.
4. Submit a pull request.

---

For more details, see the inline comments in each module and project directory.