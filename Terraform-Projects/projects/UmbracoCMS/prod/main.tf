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
    container_name       = "cmsstateprod"
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
  base_name = "cmsGeneticsProd"
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
}

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
  app_insights_conn_str_1 = module.app_insights.app1_connection_string
  app_insights_conn_str_2 = module.app_insights.app2_connection_string
  vnet_subnet_id        = data.azurerm_subnet.subnet.id
  tags                  = var.tags

  app1_app_settings = {
    "WEBSITE_STACK"                         = "DOTNETCORE"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.app_insights.app1_instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.app_insights.app1_connection_string
    "XDT_MicrosoftApplicationInsights_Mode" = "default"
    "ASPNETCORE_ENVIRONMENT"                = "Production"
    # "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_conn_str_1
  }

  app2_app_settings = var.app2_name != "" ? {
    "WEBSITE_STACK"                         = "DOTNETCORE"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.app_insights.app2_instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.app_insights.app2_connection_string
    "XDT_MicrosoftApplicationInsights_Mode" = "default"
    "ASPNETCORE_ENVIRONMENT"                = "Production"
    # "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_conn_str_2
  } : {}

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
  ]
}

resource "azurerm_subnet" "sql_vm_subnet" {
  name                 = var.sql_vm_subnet_name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.145.0/24"]
}

module "virtual_machine" {
  source              = "../../../modules/virtual_machine"
  name                 = "DairyGenVMSql"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  vnet_subnet_id      = azurerm_subnet.sql_vm_subnet.id
  vm_size             = "Standard_E4ds_v5"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  image_publisher     = "MicrosoftSQLServer"
  image_offer         = "SQL2016SP2-WS2016"
  image_sku           = "Standard"
  image_version       = "latest"
  data_disk_count     = 1
  tags                = var.tags

  depends_on = [
    module.resource_group,
    azurerm_subnet.sql_vm_subnet
  ]
}
