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
    container_name       = "ytoolstateprod"
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
  base_name = "ionToolProd"
}

# Resource Group Module
module "resource_group" {
  source    = "../../../modules/resource_group"
  base_name = local.base_name
  location  = var.location
  tags      = var.tags
}

# Fetch existing SQL Server
data "azurerm_mssql_server" "existing_sql_server" {
  name                = var.sql_server_name
  resource_group_name = var.sql_server_resource_group
}

# Fetch existing elastic pool
data "azurerm_mssql_elasticpool" "existing_elastic_pool" {
  name                = var.elastic_pool_name
  resource_group_name = var.sql_server_resource_group
  server_name         = var.sql_server_name
}

data "azurerm_key_vault" "example" {
  name                = "adb-Keys"
  resource_group_name = "ukstorage"
}

data "azurerm_key_vault_secret" "sql_admin_username" {
  name         = "sql-admin-username"
  key_vault_id = data.azurerm_key_vault.example.id
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-username"
  key_vault_id = data.azurerm_key_vault.example.id
}

# data "azurerm_key_vault_secret" "DevUser" {
#   name         = "RLVST_DevUser"
#   key_vault_id = data.azurerm_key_vault.example.id
# }

# data "azurerm_key_vault_secret" "Admin" {
#   name         = "RLVST_Admin"
#   key_vault_id = data.azurerm_key_vault.example.id
# }

# SQL Server Module
module "sql_server" {
  source              = "../../../modules/sql_server"
  server_id           = data.azurerm_mssql_server.existing_sql_server.id
  resource_group_name = data.azurerm_mssql_server.existing_sql_server.resource_group_name
  location            = data.azurerm_mssql_server.existing_sql_server.location
  database1_name      = var.database1_name
  elastic_pool_id     = data.azurerm_mssql_elasticpool.existing_elastic_pool.id
  tags                = var.tags
  # sql_admin_username           = var.sql_admin_username
  # sql_admin_password           = var.sql_admin_password
  sql_admin_username = data.azurerm_key_vault_secret.sql_admin_username.value
  sql_admin_password = data.azurerm_key_vault_secret.sql_admin_password.value
  sql_server_fqdn    = data.azurerm_mssql_server.existing_sql_server.fully_qualified_domain_name
  create_db_user     = var.create_db_user
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
module "app_service" {
  source                = "../../../modules/app_service"
  app_service_plan_name = var.app_service_plan_name
  resource_group_name   = module.resource_group.resource_group_name
  location              = module.resource_group.resource_group_location
  # base_name                    = var.base_name
  app1_name       = var.app1_name
  sql_server_name = data.azurerm_mssql_server.existing_sql_server.name
  # sql_admin_username           = var.sql_admin_username
  # sql_admin_password           = var.sql_admin_password
  sql_admin_username = data.azurerm_key_vault_secret.sql_admin_username.value
  sql_admin_password = data.azurerm_key_vault_secret.sql_admin_password.value
  database1_name     = module.sql_server.sql_database1_name
  app_insights_key_1 = module.app_insights.app1_instrumentation_key
  vnet_subnet_id     = data.azurerm_subnet.subnet.id
  tags               = var.tags

  depends_on = [
    module.resource_group,
    module.sql_server,
    module.app_insights,
    data.azurerm_subnet.subnet
  ]
}

data "azurerm_windows_web_app" "main_app" {
  name  = var.app1_name
  resource_group_name = module.resource_group.resource_group_name
}

module "app_service_slot" {
  source = "../../../modules/app_service_slot"
  slot_name  = "prerelease"
  app_service_id = data.azurerm_windows_web_app.main_app.id
  tags = var.tags
  configuration_source = var.app1_name

  depends_on = [module.app_service]
}