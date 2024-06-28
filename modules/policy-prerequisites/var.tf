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
