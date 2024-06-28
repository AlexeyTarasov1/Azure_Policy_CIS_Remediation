variable "management_gr_name" {
  type = string
  default = ""
  description = "Management Group Name"
}

variable "cis_remediation_policyset_assignment_id" {
  type        = string
  description = "The policy set definition id for cis_remediation"
}

variable "cis_remediation" {
  type        = list(map(string))
  description = "List of custom policy definitions for the Azure Policy remediation policyset"
}
