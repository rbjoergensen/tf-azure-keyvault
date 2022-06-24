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

# Network ACL (needs to be postfixed with the cidr eg. 201.45.11.67/32)
variable "acl_ip_whitelist" {
  type = list(string)
  default = []
}

variable "acl_default_action" {
  type = string
  default = "Allow"
}

variable "acl_service_bypass" {
  type = string
  default = "AzureServices"
}

# Access policies
variable "secret_reader_groups" {
  type = list(string)
  default = []
}

variable "vault_admin_groups" {
  type = list(string)
  default = []
}

# Identity and authentication
variable "create_az_application" {
  type = bool
  default = false
}

variable "create_managed_identity" {
  type = bool
  default = false
}

locals {
  application_name = "keyvault-${var.keyvault_name}"
  certificate_name = "keyvault-${var.keyvault_name}"
  identity_name    = "keyvault-${var.keyvault_name}"
}