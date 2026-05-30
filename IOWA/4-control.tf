###########################################################################################
#                   Enable This after Creating your infrastructure
###########################################################################################
variable "firsts_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = true
} #             KEEP THIS TRUE AT ALL TIMES, IT ENSURES THE RIGHT VARIABLES GO TO THE VM

###########################################################################################
#                   VPN CONNECTION TO AWS
###########################################################################################
variable "first_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = false
}

variable "second_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = false
}
