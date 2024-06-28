variable "management_gr_name" {
  type = string
  default = ""
  description = "Management Group Name"
}

variable "man_identity_rg_name" {
  type        = string
  description = "Resource Group where we store Managed Identity for Remediation"
}

variable "man_identity_name" {
  type        = string
  description = "Managed Identity For Remediation Resources Name"
}

variable "alertResourceGroupName" {
  type        = string
  description = "Activity Alerts Resource Group name"
}

variable "alertResourceGroupLocation" {
  type        = string
  description = "Location where we create resource group for activity alerts"
}

variable "actionGroupName" {
  type        = string
  description = "Name of the Action Group"
}

variable "actionGroupRG" {
  type        = string
  description = "Resource Group containing the Action Group"
}

variable "actionGroupSubID" {
  type        = string
  description = "Resource Group containing the Action Group"
}
