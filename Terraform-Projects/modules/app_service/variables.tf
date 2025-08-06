variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "appinsight1" {
  type        = string
  description = "web app base name"
  default     = null
}

variable "appinsight2" {
  type        = string
  description = "web app base name"
  default     = null
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

variable "sql_server_name" {
  description = "The name of the SQL server"
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

variable "sql_admin_username" {
  description = "The SQL admin username"
  type        = string
}

variable "sql_admin_password" {
  description = "The SQL admin password"
  type        = string
}

variable "app_insights_key_1" {
  description = "The instrumentation key for the first Application Insights."
  type        = string
}

variable "app_insights_key_2" {
  description = "The instrumentation key for the second Application Insights."
  type        = string
  default     = ""
}

variable "vnet_subnet_id" {
  description = "The instrumentation key for the first Application Insights."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "app1_app_settings" {
  description = "App settings for App1"
  type        = map(string)
  default     = {}
}

variable "app2_app_settings" {
  description = "App settings for App2"
  type        = map(string)
  default     = {}
}

variable "app_insights_conn_str_1" {
  type        = string
  description = "App Insights connection string for app1"
}

variable "app_insights_conn_str_2" {
  type        = string
  description = "App Insights connection string for app2"
  default     = null
}