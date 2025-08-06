variable "keyvault_name" {
  type        = string
  description = "key vault name"
}

variable "location" {
  type        = string
  description = "key vault location"
}

variable "resource_group_name" {
  type        = string
  description = "resource group to create the key vault"
}

variable "secret_value" {
  type        = string
  description = "value of the secret to be stored"
}

variable "secret_name" {
  type        = string
  description = "secret name to be stored in keyvault"
}