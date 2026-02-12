output "gcp_vpc_cidr" {
  description = "This is the CIDR range for the GCP VPC"
  value       = try(google_compute_subnetwork.nihonmachi_subnet01.ip_cidr_range, "not-created-yet")
}
output "gcp-asn" {
  description = "This is the asn for gcp"
  value       = try(google_compute_router.gcp-to-aws-cloud-router[0].bgp[0].asn, "not-created-yet")
}
output "gcp-vpn-ip-1" {
  description = "This is the first IP for gcp"
  value       = try(google_compute_ha_vpn_gateway.gcp-to-aws-vpn-gw[0].vpn_interfaces[0].ip_address, "not-created-yet")
}
output "gcp-vpn-ip-2" {
  description = "This is the second IP for gcp"
  value       = try(google_compute_ha_vpn_gateway.gcp-to-aws-vpn-gw[0].vpn_interfaces[1].ip_address, "not-created-yet")
}

# Because Modules don't work, this is my work around
#                LABOR LABOR LABOR LABOR 

variable "firsts_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = true
}

#  This extracts the data that is necessasry to create a succesfull  VPN from GCP to AWS
data "terraform_remote_state" "aws" {
  count   = var.firsts_workflow_enabled ? 1 : 0
  backend = "local"
  config = {
    path = "../Japan/secrets/terraform.tfstate"
  }
}

locals {
  # AWS      
  aws-asn                  = try(data.terraform_remote_state.aws[0].outputs.aws-asn, "not-created-yet")
  aws-tunnel1-address-vpn1 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel1-address-vpn1, "not-created-yet")
  aws-tunnel2-address-vpn1 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel2-address-vpn1, "not-created-yet")
  aws-tunnel1-address-vpn2 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel1-address-vpn2, "not-created-yet")
  aws-tunnel2-address-vpn2 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel2-address-vpn2, "not-created-yet")
  tgw_id                   = try(data.terraform_remote_state.aws[0].outputs.aws_tgw_id, "not-created-yet")
  tunnel1_psk1             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk1, "not-created-yet")
  tunnel1_psk2             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk2, "not-created-yet")
  tunnel1_psk3             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk3, "not-created-yet")
  tunnel1_psk4             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk4, "not-created-yet")
  internal1-cidr1          = try(data.terraform_remote_state.aws[0].outputs.internal1-cidr1, "not-created-yet")
  internal1-cidr2          = try(data.terraform_remote_state.aws[0].outputs.internal1-cidr2, "not-created-yet")
  internal2-cidr1          = try(data.terraform_remote_state.aws[0].outputs.internal2-cidr1, "not-created-yet")
  internal2-cidr2          = try(data.terraform_remote_state.aws[0].outputs.internal2-cidr2, "not-created-yet")
  aws_cidr                 = try(data.terraform_remote_state.aws[0].outputs.aws-cidr, "not-created-yet")
}

# This is to extract some database data from Japan to use in the startup script for the VM in Iowa
data "terraform_remote_state" "japan" {
  count   = var.firsts_workflow_enabled ? 1 : 0
  backend = "local"
  config = {
    path = "../Japan/secrets/terraform.tfstate"
  }
}
