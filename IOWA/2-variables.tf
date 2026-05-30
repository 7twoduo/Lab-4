############################################################
# Startup Script Variables
############################################################

locals {
  startup_script = templatefile("${path.module}/startup.sh.tftpl", {
    TOKYO_RDS_HOST = try(data.terraform_remote_state.japan[0].outputs.db_hostname, "not-created-yet")
    TOKYO_RDS_PORT = try(data.terraform_remote_state.japan[0].outputs.db_port, "not-created-yet")
    TOKYO_RDS_USER = try(data.terraform_remote_state.japan[0].outputs.db_username, "not-created-yet")
    SECRET_NAME    = try(data.terraform_remote_state.japan[0].outputs.secret_name, "not-created-yet")
    DB_PASS        = try(data.terraform_remote_state.japan[0].outputs.db_password, "not-created-yet")
  })
}



variable "gcp_project_id" {
  type    = string
  default = "gcp-mastery-495919"
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}
variable "gcp_zone" {
  type    = string
  default = "us-central1-f"
}
# Students provide these
variable "nihonmachi_vpc_cidr" {
  type    = string
  default = "10.250.0.0/16"
}

variable "nihonmachi_subnet_cidr" {
  type    = string
  default = "10.250.1.0/24"
}
variable "nihonmachi_subnet_cidr2" {
  type    = string
  default = "10.250.2.0/24"
}


# Who is allowed to access the NY private URL (VPN/TGW subnets)
variable "allowed_vpn_cidrs" {
  type    = list(string)
  default = ["10.200.0.0/16", "10.100.0.0/16", "0.0.0.0/0"] # students: add AWS Tokyo VPC CIDR, corp VPN CIDR, etc.
}

# # Tokyo RDS endpoint (private resolvable/reachable over VPN)
# variable "tokyo_rds_host" {
#   type    = string
#   default = "sss"
# }

# variable "tokyo_rds_port" {
#   type    = number
#   default = 3306
# }

# # DB user is OK to store as plain var; password should not be in TF state (use Secret Manager)
# variable "tokyo_rds_user" {
#   type    = string
#   default = "sss"
# }

# # Secret name holding DB password (created outside TF or by TF—your choice)
# variable "db_password_secret_name" {
#   type    = string
#   default = "sss"
# }