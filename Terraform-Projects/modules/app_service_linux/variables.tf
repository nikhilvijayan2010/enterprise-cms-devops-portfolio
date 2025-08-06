
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the Linux App Service Plan"
  type        = string
}

# variable "payload_app_name" {
#   description = "The name of the Payload CMS App Service"
#   type        = string
# }

# variable "payload_secret" {
#   description = "The secret key for Payload CMS"
#   type        = string
# }

# variable "database_uri" {
#   description = "The URI for the database connection"
#   type        = string
# }

# variable "preview_secret" {
#   description = "The secret key for preview functionality"
#   type        = string
# }

# variable "cron_secret" {
#   description = "The secret key for cron jobs"
#   type        = string
# }

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}


variable "app1_name" {
  description = "The name of the Linux Web App"
  type        = string
}

variable "vnet_subnet_id" {
  description = "The ID of the subnet to integrate the app with"
  type         = string
}