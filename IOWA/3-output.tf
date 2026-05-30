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
############################################################
# Outputs
############################################################

output "nihonmachi_public_http_lb_ip" {
  value = google_compute_address.nihonmachi_lb_ip01.address
}

output "nihonmachi_public_http_url" {
  value = "http://${google_compute_address.nihonmachi_lb_ip01.address}"
}

output "nihonmachi_private_subnet_cidr" {
  value = google_compute_subnetwork.nihonmachi_subnet01.ip_cidr_range
}

output "nihonmachi_proxy_only_subnet_cidr" {
  value = google_compute_subnetwork.nihonmachi_proxy_only_uscentral1.ip_cidr_range
}




# Because Modules don't work, this is my work around
#                LABOR LABOR LABOR LABOR 

#  This extracts the data that is necessasry to create a succesfull  VPN from GCP to AWS
data "terraform_remote_state" "aws" {
  count   = var.firsts_workflow_enabled ? 1 : 0
  backend = "local"
  config = {
    path = abspath("${path.module}/../JAPAN/secrets/terraform.tfstate")
  }
}

locals {
  # AWS      
  aws-asn                  = try(data.terraform_remote_state.aws[0].outputs.aws-asn, "65005")
  aws-tunnel1-address-vpn1 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel1-address-vpn1, "not-created-yet")
  aws-tunnel2-address-vpn1 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel2-address-vpn1, "not-created-yet")
  aws-tunnel1-address-vpn2 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel1-address-vpn2, "not-created-yet")
  aws-tunnel2-address-vpn2 = try(data.terraform_remote_state.aws[0].outputs.aws-tunnel2-address-vpn2, "not-created-yet")
  tgw_id                   = try(data.terraform_remote_state.aws[0].outputs.aws_tgw_id, "not-created-yet")
  tunnel1_psk1             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk1, "not-created-yet")
  tunnel1_psk2             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk2, "not-created-yet")
  tunnel1_psk3             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk3, "not-created-yet")
  tunnel1_psk4             = try(data.terraform_remote_state.aws[0].outputs.tunnel1_psk4, "not-created-yet")
  internal1-cidr1          = try(data.terraform_remote_state.aws[0].outputs.internal1-cidr1, "10.0.0.0/16")
  internal1-cidr2          = try(data.terraform_remote_state.aws[0].outputs.internal1-cidr2, "10.0.0.0/16")
  internal2-cidr1          = try(data.terraform_remote_state.aws[0].outputs.internal2-cidr1, "10.0.0.0/16")
  internal2-cidr2          = try(data.terraform_remote_state.aws[0].outputs.internal2-cidr2, "10.0.0.0/16")
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
