variable "appinsight1" {
  description = "The name of the first Application Insights resource."
  type        = string
}

variable "appinsight2" {
  description = "The name of the second Application Insights resource."
  type        = string
  default     = ""
}

variable "location" {
  description = "The location of the resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}
