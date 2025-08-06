# variable "sql_server_name" {
#   type        = string
#   description = "SQL DB base name"
# }

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
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
  description = "The name of the first database."
  type        = string
}

variable "database2_name" {
  description = "The name of the second database."
  type        = string
  default     = ""
}

variable "server_id" {
  description = "The ID of the existing SQL Server."
  type        = string
}

variable "elastic_pool_id" {
  description = "The ID of the existing elastic pool"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
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