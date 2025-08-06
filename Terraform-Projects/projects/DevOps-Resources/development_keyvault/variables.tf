variable "location" {
  description = "The location of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "keyvault_name" {
  type        = string
  description = "key vault name"
}

variable "subscription_id" {
  description = "The subscription ID for the Azure provider"
  type        = string
}

# variable "project1_dev_api_key" {
#   description = "Project 1 development API key"
#   type        = string
# }

# variable "project2_dev_db_password" {
#   description = "Project 2 development database password"
#   type        = string
# }

# variable "project2_dev_api_key" {
#   description = "Project 2 development API key"
#   type        = string
# }

# variable "project1_prod_db_password" {
#   description = "Project 1 production database password"
#   type        = string
# }

# variable "project1_prod_api_key" {
#   description = "Project 1 production API key"
#   type        = string
# }

# variable "project2_prod_db_password" {
#   description = "Project 2 production database password"
#   type        = string
# }

# variable "project2_prod_api_key" {
#   description = "Project 2 production API key"
#   type        = string
# }

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    BusinessOwner = "DevelopmentTeam"
    Environment   = "Development"
    Project       = "RLVarietySelectionTool"
    CreatedBy     = "Jamiu Ejiwumi"
    Sector        = "All"
    ManagedBy     = "Terraform"
  }
}

# variable "secret_name" {
#   description = "The name of the secret"
#   type        = string
# }

# variable "secret_value" {
#   description = "The value of the secret"
#   type        = string
# }