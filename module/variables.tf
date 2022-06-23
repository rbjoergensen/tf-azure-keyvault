# Resource locality
variable "tenant_id" {
  type = string
}

variable "resourcegroup" {
  type = string
}

variable "location" {
  type = string
}

# Key vault settings
variable "keyvault_name" {
  type = string
}

variable "enable_purge_protection" {
  type = bool
  default = false
}

# Identity and authentication
variable "identity_name" {
  type = string
}

variable "application_name" {
  type = string
}