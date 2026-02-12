
#                  Output Blocks
output "region" {
  value = data.aws_region.current.region
}
output "vpc_cidr" {
  value = aws_vpc.Star.cidr_block
}
output "Ec2_transit_gateway" {
  value = aws_ec2_transit_gateway.shinjuku_tgw01.id
}

#         Database Outputs 
output "db_username" {
  value = var.db_username
  sensitive = true
}
output "db_password" {
  value = random_password.master.result
  sensitive = true
}
output "db_hostname" {
  value = aws_db_instance.below_the_valley.address
  sensitive = true
}
output "db_port" {
  value = aws_db_instance.below_the_valley.port
  sensitive = true
}


output "aws-asn" {
  description = "ASN for AWS, it makes this more plugable"
  value       = try(aws_ec2_transit_gateway.shinjuku_tgw01.amazon_side_asn, "not-created-yet")
}

# First
output "aws-tunnel1-address-vpn1" {
  description = "Tunnel 1 address for VPN Connection 1"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn1[0].tunnel1_address, "not-created-yet")
}
output "aws-tunnel2-address-vpn1" {
  description = "Tunnel 2 address for VPN Connection 1"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn1[0].tunnel2_address, "not-created-yet")
}

# Second

output "aws-tunnel1-address-vpn2" {
  description = "Tunnel 1 address for VPN Connection 2"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn2[0].tunnel1_address, "not-created-yet")
}
output "aws-tunnel2-address-vpn2" {
  description = "Tunnel 2 address for VPN Connection 2"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn2[0].tunnel2_address, "not-created-yet")
}
output "tunnel1_psk1" {
  description = "Randomly generated pre-shared key for Tunnel 1 of VPN Connection 1"
  value       = random_password.tunnel1_psk1.result
  sensitive   = true
}
output "tunnel1_psk2" {
  description = "Randomly generated pre-shared key for Tunnel 2 of VPN Connection 1"
  value       = random_password.tunnel1_psk2.result
  sensitive   = true
}
output "tunnel1_psk3" {
  description = "Randomly generated pre-shared key for Tunnel 1 of VPN Connection 2"
  value       = random_password.tunnel1_psk3.result
  sensitive   = true
}
output "tunnel1_psk4" {
  description = "Randomly generated pre-shared key for Tunnel 2 of VPN Connection 2"
  value       = random_password.tunnel1_psk4.result
  sensitive   = true
}

output "internal1-cidr1" {
  description = "Internal CIDR for Tunnel 1 of VPN Connection 1"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn1[0].tunnel1_inside_cidr, "not-created-yet")
}
output "internal1-cidr2" {
  description = "Internal CIDR for Tunnel 2 of VPN Connection 1"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn1[0].tunnel2_inside_cidr, "not-created-yet")
}
output "internal2-cidr1" {
  description = "Internal CIDR for Tunnel 1 of VPN Connection 2"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn2[0].tunnel1_inside_cidr, "not-created-yet")
}
output "internal2-cidr2" {
  description = "Internal CIDR for Tunnel 2 of VPN Connection 2"
  value       = try(aws_vpn_connection.aws-to-gcp-vpn2[0].tunnel2_inside_cidr, "not-created-yet")
}
output "aws-cidr" {
  description = "CIDR block for the AWS VPC"
  value       = aws_vpc.Star.cidr_block
}

# Because Modules don't work, this is my work around
#                LABOR LABOR LABOR LABOR 
variable "firsts_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = true
}
data "terraform_remote_state" "gcp" {
  count   = var.firsts_workflow_enabled ? 1 : 0
  backend = "local"
  config = {
    path = "../Iowa/secrets/terraform.tfstate"
  }
}

locals {
  #  GCP
  gcp_cidr     = try(data.terraform_remote_state.gcp[0].outputs.gcp_vpc_cidr, "20.20.20.20/32")
  gcp-asn      = try(data.terraform_remote_state.gcp[0].outputs.gcp-asn, "65725")
  gcp-vpn-ip-1 = try(data.terraform_remote_state.gcp[0].outputs.gcp-vpn-ip-1, "20.20.20.20")
  gcp-vpn-ip-2 = try(data.terraform_remote_state.gcp[0].outputs.gcp-vpn-ip-2, "20.20.20.20")

}
