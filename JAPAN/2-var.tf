#                                           Local Blocks
locals {
  # EC2_SG_Traffic = aws_security_group.EC2_SG.id
  db_instance_id = aws_db_instance.below_the_valley.id
  terradbname    = aws_db_instance.below_the_valley.tags["terraname"]
  ec2_ami_local  = data.aws_ami.amazon_linux.id
  vpc_id         = aws_vpc.Star.id
  account_id     = data.aws_caller_identity.current.account_id
  name_prefix    = var.Environment
  Environment    = aws_vpc.Star.tags["Name"]


}
#                                           Variable Blocks
variable "Environment" {
  description = "VPC ID, this is best to be a locals variable"
  type        = string
  default     = "star" #lower case is just better when writing code Remember that!!!!!!
}
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-northeast-1"
}
variable "second_aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "sa-east-1"
}
variable "public_subnet" {
  description = "The AWS region to deploy resources in"
  type        = bool
  default     = true
}
variable "private_subnet" {
  description = "The AWS region to deploy resources in"
  type        = bool
  default     = false
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.100.0.0/16"
}
variable "public_subnet_cidr1" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.100.1.0/24"
}
variable "public_subnet_cidr2" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.100.2.0/24"
}
variable "private_subnet_cidr1" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.100.11.0/24"
}
variable "private_subnet_cidr2" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.100.12.0/24"
}
variable "public_access_cidr" {
  description = "The CIDR block for public access"
  type        = string
  default     = "0.0.0.0/0"
}
variable "db_username" {
  description = "The username for the RDS database"
  type        = string
  default     = "admin"
}
variable "sns_email" {
  description = "Put Your email below"
  type        = string
  default     = "markedsync@gmail.com"
  #Remember you have to confirm your subscription for this to work
}
variable "parameter_location" {
  description = "The location in Parameter Store for some RDS details"
  type        = string
  default     = "/lab/db/"
}
variable "s3_bucket_no_access" {
  description = "No public access to bucket"
  type        = bool
  default     = true
}

variable "cloudwatch_log_retention_days" {
  description = "The amount of days waf logs will be retained."
  type        = string
  default     = "7"
}

#                                           Data Blocks

#Data Block to pull AMI for Amazon Linux 2023
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}
data "aws_availability_zones" "available" {
  state = "available"
}