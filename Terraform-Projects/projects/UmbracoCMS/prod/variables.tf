#############################
# 🔧 Azure Setup
#############################

variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

variable "location" {
  description = "The Azure region for resource deployment."
  type        = string
  validation {
    condition     = contains(["uksouth", "ukwest", "westeurope", "northeurope"], lower(var.location))
    error_message = "Only UK and EU regions are allowed (e.g., uksouth, westeurope)."
  }
}

#############################
# 🧾 Metadata & Naming
#############################

variable "base_name" {
  description = "The base name for all project resources."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default = {
    BusinessOwner = "DevelopmentTeam"
    Environment   = "Production"
    Project       = "cms"
    CreatedBy     = "Jamiu Ejiwumi"
    ProjectManager= "Thilini Perera"
    Sector        = "Agriculture"
    ProvisionedBy = "Terraform"
  }
}

#############################
# 🌐 Networking
#############################

variable "vnet_name" {
  description = "The name of the existing virtual network."
  type        = string
  default     = "WebServicesVNET"
}

variable "vnet_resource_group" {
  description = "The resource group where the virtual network exists."
  type        = string
}

variable "app_subnet_name" {
  description = "The name of the subnet used by App Services."
  type        = string
}

variable "sql_vm_subnet_name" {
  description = "Name of the subnet for SQL VM"
  type        = string
}
#############################
# 🗄️ Storage
#############################

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "storage_container_name" {
  description = "The name of the blob storage container."
  type        = string
}

#############################
# 🧩 SQL Server & Databases
#############################

variable "sql_server_name" {
  description = "The name of the existing SQL Server."
  type        = string
}

variable "sql_server_resource_group" {
  description = "The resource group where the SQL Server resides."
  type        = string
}

variable "sql_admin_username" {
  description = "The administrator username for SQL Server."
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "The administrator password for SQL Server."
  type        = string
  sensitive   = true
}

variable "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server."
  type        = string
}

variable "elastic_pool_name" {
  description = "The name of the existing SQL elastic pool."
  type        = string
}

variable "database1_name" {
  description = "The name of the first SQL Database."
  type        = string
}

variable "database2_name" {
  description = "The name of the second SQL Database."
  type        = string
  default     = ""
}

variable "create_db_user" {
  description = "Boolean to control whether to run the DB user creation script."
  type        = bool
}

#############################
# 🖥️ App Services
#############################

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
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

#############################
# 📊 Monitoring
#############################

variable "appinsight1" {
  description = "The name of the first Application Insights resource."
  type        = string
}

variable "appinsight2" {
  description = "The name of the second Application Insights resource."
  type        = string
  default     = ""
}

#############################
# 💻 Virtual Machine
#############################

variable "admin_password" {
  description = "The administrator password for the Windows virtual machine."
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}


#############################
# 💻 Appsettings
#############################

variable "db_user" {
  description = "App DB user"
  type        = string
}

variable "db_password" {
  description = "App DB password"
  type        = string
  sensitive   = true
}

variable "app1_app_settings" {
  description = "Key-value app settings for app1"
  type        = map(string)
  default     = {}
}

variable "app2_app_settings" {
  description = "Key-value app settings for app2"
  type        = map(string)
  default     = {}
}

# variable "app_insights_conn_str_1" {
#   description = "Application Insights connection string for app1"
#   type        = string
# }

# variable "app_insights_conn_str_2" {
#   description = "Application Insights connection string for app2"
#   type        = string
#   default     = null
# }