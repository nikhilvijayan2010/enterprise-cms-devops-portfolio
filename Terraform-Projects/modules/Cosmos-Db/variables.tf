variable "base_name" {
  type        = string
  description = "The cosmosdb group base name"
}

variable "location" {
  type        = string
  description = "The location for the cosmosdb deployment"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name to create the cosmosdb"
}
