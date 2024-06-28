data "azurerm_management_group" "currentMG" {
  name = var.management_gr_name
}

variable "management_gr_name" {
  type = string
  default = ""
  description = "Management Group Name"
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
