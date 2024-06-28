variable "management_gr_name" {
  type = string
  default = ""
  description = "Management Group Name"
}

variable "cis_policy" {
  type        = list(map(string))
  description = "List of custom policy definitions for the Azure Policy remediation policyset"
  default     = []
}
