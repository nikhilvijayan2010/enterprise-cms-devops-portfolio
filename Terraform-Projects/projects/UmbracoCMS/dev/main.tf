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
    container_name       = "cmsstatenew1"
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
  base_name = "cmsGenetics"
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

# SQL Server Module
module "sql_server" {
  source              = "../../../modules/sql_server"
  server_id           = data.azurerm_mssql_server.existing_sql_server.id
  resource_group_name = data.azurerm_mssql_server.existing_sql_server.resource_group_name
  location            = data.azurerm_mssql_server.existing_sql_server.location
  database1_name      = var.database1_name
  database2_name      = var.database2_name
  elastic_pool_id     = data.azurerm_mssql_elasticpool.existing_elastic_pool.id
  tags                = var.tags
  sql_admin_username  = var.sql_admin_username
  sql_admin_password  = var.sql_admin_password
  sql_server_fqdn     = data.azurerm_mssql_server.existing_sql_server.fully_qualified_domain_name
  create_db_user      = var.create_db_user
  # vnet_subnet_id               = data.azurerm_subnet.sql_subnet.id
}

# Add the import resource
# resource "null_resource" "import_bacpac" {
#   provisioner "local-exec" {
#     command = <<EOT
#       az sql db import --resource-group ${module.sql_server.resource_group_name} \
#         --server ${module.sql_server.server_id} \
#         --name ${azurerm_mssql_database.database1.name} \
#         --admin-user ${var.sql_admin_username} \
#         --admin-password ${var.sql_admin_password} \
#         --storage-key "8t+9WM2sEky3Fazu+AStxh6LuQ==" \
#         --storage-key-type StorageAccessKey \
#         --storage-uri ${var.bacpac_url1}
#     EOT
#   }
#   depends_on = [azurerm_mssql_database.database1]
# }

# Application Insights Module
module "app_insights" {
  source              = "../../../modules/app_insights"
  appinsight1         = var.appinsight1
  appinsight2         = var.appinsight2
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

data "azurerm_subnet" "sql_subnet" {
  name                 = var.sql_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

module "app_service" {
  source                = "../../../modules/app_service"
  app_service_plan_name = var.app_service_plan_name
  resource_group_name   = module.resource_group.resource_group_name
  location              = module.resource_group.resource_group_location
  appinsight1           = var.appinsight1
  appinsight2           = var.appinsight2
  app1_name             = var.app1_name
  app2_name             = var.app2_name
  sql_server_name       = data.azurerm_mssql_server.existing_sql_server.name
  sql_admin_username    = var.sql_admin_username
  sql_admin_password    = var.sql_admin_password
  database1_name        = module.sql_server.sql_database1_name
  database2_name        = module.sql_server.sql_database2_name
  app_insights_key_1    = module.app_insights.app1_instrumentation_key
  app_insights_key_2    = module.app_insights.app2_instrumentation_key
  vnet_subnet_id        = data.azurerm_subnet.subnet.id
  tags                  = var.tags

  depends_on = [
    module.resource_group,
    module.sql_server,
    module.app_insights,
    data.azurerm_subnet.subnet
  ]
}

module "storage_account" {
  source                 = "../../../modules/storage_account"
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  resource_group_name    = module.resource_group.resource_group_name
  location               = module.resource_group.resource_group_location
  tags                   = var.tags
  depends_on = [
    module.resource_group,
    module.sql_server,
    module.app_insights,
    data.azurerm_subnet.subnet
  ]
}