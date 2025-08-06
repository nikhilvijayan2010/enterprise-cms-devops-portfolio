variable "vnet_subnet_id" {
  description = "The subnet ID from an existing virtual network"
  type        = string
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the VM"
}

variable "location" {
  type        = string
  description = "Region to deploy VM in"
}

variable "name" {
  type        = string
  description = "VM name"
}

variable "vm_size" {
  type        = string
  default     = "Standard_E4ds_v5"
  description = "Size of the VM"
}

variable "admin_username" {
  type        = string
  description = "Admin username"
}

variable "admin_password" {
  type        = string
  description = "Admin password"
  sensitive   = true
}

variable "image_publisher" {
  type        = string
  default     = "MicrosoftSQLServer"
}

variable "image_offer" {
  type        = string
  default     = "SQL2016SP2-WS2016"
}

variable "image_sku" {
  type        = string
  default     = "Standard"
}

variable "image_version" {
  type        = string
  default     = "latest"
}

variable "data_disk_count" {
  type        = number
  default     = 0
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "sql_data_disk_size_gb" {
  description = "Size of the SQL data disk in GB"
  default     = 2048
}

variable "sql_log_disk_size_gb" {
  description = "Disk size for SQL log disk"
  default     = 1024
}