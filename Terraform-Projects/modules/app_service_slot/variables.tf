variable "app_service_id" {
  description = "The ID of the parent Windows Web App."
  type        = string
}

variable "slot_name" {
  description = "The name of the deployment slot."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the slot."
  type        = map(string)
  default     = {}
}


variable "configuration_source" {
  description = "Name of the App Service to clone configuration from (e.g., production slot)"
  type        = string
  default     = null
}