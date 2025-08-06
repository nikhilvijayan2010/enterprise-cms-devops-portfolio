variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

variable "location" {
  type        = string
  description = "The location for the resource group deployment"
}

# variable "administrator_login" {
#   type        = string
#   description = "SQL admin login"
# }

# variable "administrator_login_password" {
#   type        = string
#   description = "SQL admin password"
#   sensitive   = true
# }

variable "database1_name" {
  description = "The name of the first SQL Database."
  type        = string
}

variable "database2_name" {
  description = "The name of the second SQL Database."
  type        = string
  default     = ""
}

variable "base_name" {
  type        = string
  description = "web app base name"
}

variable "app1_name" {
  description = "The name of the first App Service."
  type        = string
}

variable "app2_name" {
  description = "The name of the second App Service."
  type        = string
  default     = ""
}

variable "appinsight1" {
  description = "The name of the first Application Insights resource."
  type        = string
}

variable "appinsight2" {
  description = "The name of the second Application Insights resource."
  type        = string
  default     = ""
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "sql_server_name" {
  type        = string
  description = "SQL DB base name"
}

variable "sql_server_resource_group" {
  description = "The resource group name of the existing SQL Server."
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing Virtual Network"
  type        = string
  default     = "WebServicesVNET"
}

variable "vnet_resource_group" {
  description = "The resource group name of the existing virtual network."
  type        = string
}

variable "app_subnet_name" {
  description = "The name of the subnet for app services"
  type        = string
  default     = "Subnet02-Apps"
}

variable "sql_subnet_name" {
  description = "The name of the subnet for SQL server"
  type        = string
  default     = "Subnet01-SQL"
}

variable "elastic_pool_name" {
  description = "The name of the existing elastic pool"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    BusinessOwner = "DevelopmentTeam"
    Environment   = "Development"
    Project       = "cms"
    CreatedBy     = "Jamiu Ejiwumi"
    Sector        = "All"
    ManagedBy     = "Terraform"
  }
}

variable "sql_admin_username" {
  description = "The SQL admin username"
}

variable "sql_admin_password" {
  description = "The SQL admin password"
  sensitive   = true
}

variable "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL server"
}

variable "create_db_user" {
  description = "Boolean to control whether the local-exec provisioner should run to create a database user"
  type        = bool
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "storage_container_name" {
  description = "The name of the storage container"
  type        = string
}
