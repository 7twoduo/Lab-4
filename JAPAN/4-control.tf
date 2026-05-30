
######################################################################
#             Databse Secret Location in Secret Manager
######################################################################
# lab/rds/mysqv2
variable "secret_location" {
  description = "The location in Secrets Manager to store the RDS credentials"
  type        = string
  default     = "lab/rds/mysql119"
}
######################################################################
#      Enable this after you have created all the other statefiles
######################################################################

variable "firsts_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = false
}


######################################################################
#                       TGW JAPAN TO TGW AWS SAO-PAULO
######################################################################

variable "transit_peering_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = false
}

variable "transit-peering-route" {
  description = "Enable routing assocation to the peering transit gateway"
  type        = bool
  default     = false
}

######################################################################
#                       VPN TO GCP PROCESS
######################################################################
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



variable "three_workflow_enabled" {
  description = "Creates the Routes in the Route tables"
  type        = bool
  default     = false
}

######################################################################################################
######################################################################################################

# Explanation: Shinjuku Station is the hub—Tokyo is the data authority.
resource "aws_ec2_transit_gateway" "shinjuku_tgw01" {
  description                     = "shinjuku-tgw01 (Tokyo hub)"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  amazon_side_asn                 = 65001
  tags = {
    Name = "shinjuku-tgw119"
  }

}
data "aws_ec2_transit_gateway" "attachment" {
  count  = var.transit_peering_enabled ? 1 : 0
  region = "sa-east-1"
  filter {
    name   = "tag:Name"
    values = ["liberdade-tgw119"]

  }
}
# Connects Japan to Sao Paulo
resource "aws_ec2_transit_gateway_peering_attachment" "shinjuku_to_liberdade_peer01" {
  count                   = var.transit_peering_enabled ? 1 : 0
  transit_gateway_id      = aws_ec2_transit_gateway.shinjuku_tgw01.id
  peer_region             = "sa-east-1"
  peer_transit_gateway_id = data.aws_ec2_transit_gateway.attachment[0].id # created in Sao Paulo module/state
  tags = {
    Name = "shinjuku-to-liberdade-peer119"
  }
}