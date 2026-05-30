######################################################################
#                 Secrets Manager Variable
######################################################################
variable "secret_location" {
  description = "The location in Secrets Manager to store the RDS credentials"
  type        = string
  default     = "lab/rds/mysql119"
}
######################################################################
#                        TGW SAO to TGW JAPAN
######################################################################

# Use if terraform doesn't return an identifier
#import {
#to = aws_lb.hidden_alb
#  id = "arn:aws:elasticloadbalancing:sa-east-1:814910273374:loadbalancer/app/LoadExternal/4c54ac272e75304f"
#}

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

############################# TGW PROBLEM   ####################################################    

# Explanation: Liberdade is São Paulo’s Japanese town—local doctors, local compute, remote data.
resource "aws_ec2_transit_gateway" "liberdade_tgw01" {
  provider                        = aws.saopaulo
  description                     = "liberdade-tgw01 (Sao Paulo spoke)"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "liberdade-tgw119"
  }
}
data "aws_ec2_transit_gateway_peering_attachment" "attachment" {
  count  = var.transit_peering_enabled ? 1 : 0
  region = "ap-northeast-1"
  tags = {
    Name = "shinjuku-to-liberdade-peer119"
  }
}