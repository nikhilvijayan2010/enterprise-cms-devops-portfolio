variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

variable "location" {
  type        = string
  description = "The location for the resource group deployment"
}



variable "app1_name" {
  description = "The name of the first App Service."
  type        = string
}

variable "appinsight1" {
  description = "The name of the first Application Insights resource."
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing Virtual Network"
  type        = string
}

variable "vnet_resource_group" {
  description = "The resource group name of the existing virtual network."
  type        = string
}

variable "app_subnet_name" {
  description = "The name of the subnet for app services"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    BusinessOwner = "DevelopmentTeam"
    Environment   = "Development"
    Project       = "ProjectDemeter"
    CreatedBy     = "Jamiu Ejiwumi"
    Sector        = "All"
    ManagedBy     = "Terraform"
  }
}