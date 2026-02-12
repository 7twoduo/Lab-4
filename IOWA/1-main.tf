# Providers
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "local" {
    path = "secrets/terraform.tfstate"
  }
}

provider "google" {
  project     = var.gcp_project_id
  credentials = file("${path.module}/iowa-link.json")
  region      = var.gcp_region
  zone        = var.gcp_zone
}

# Network and Subnet resources or VPC and subnets

# Explanation: Chewbacca builds the tunnels; Nihonmachi VPC is the NY clinic’s private street grid.
#  This is the VPC architecture
resource "google_compute_network" "nihonmachi_vpc01" {
  name                    = "nihonmachi-vpc01"
  auto_create_subnetworks = false

  #routing_mode                              = "GLOBAL"
  #bgp_best_path_selection_mode              = "STANDARD"
}
# This is the public subnet—because some resources may need internet access (NAT, bastion, etc).
resource "google_compute_subnetwork" "nihonmachi_subnet01" {
  name                     = "nihonmachi-subnet01"
  ip_cidr_range            = var.nihonmachi_subnet_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.nihonmachi_vpc01.id
  private_ip_google_access = true
}

# Proxy ONLY subnet for Google Managed Proxy LB
resource "google_compute_subnetwork" "nihonmachi_proxy_only_uscentral1" {
  name          = "nihonmachi-proxy-only-uscentral1"
  region        = var.gcp_region
  network       = google_compute_network.nihonmachi_vpc01.id
  ip_cidr_range = "10.250.200.0/24"   # pick an unused range

  purpose = "REGIONAL_MANAGED_PROXY"
  role    = "ACTIVE"
}

# Firewall or security group resources

# # Explanation: Chewbacca guards the clinic door—HTTPS is allowed ONLY from inside the corridor.
resource "google_compute_firewall" "nihonmachi_allow_https_from_vpn01" {
  name = "nihonmachi-allow-https-from-vpn01"
  for_each = {
    uno = google_compute_network.nihonmachi_vpc01.name
  }
  network = each.value

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = var.allowed_vpn_cidrs
  target_tags   = ["nihonmachi-app"]
}

resource "google_compute_firewall" "nihonmachi_allow_https_from_vpn03" {
  name = "nihonmachi-allow-https-from-vpn03"
  for_each = {
    uno = google_compute_network.nihonmachi_vpc01.name
  }
  network = each.value

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = var.allowed_vpn_cidrs
  target_tags   = ["nihonmachi-app"]
}
resource "google_compute_firewall" "nihonmachi_allow_https_from_vpn02" {
  name = "nihonmachi-allow-https-from-vpn02"
  for_each = {
    uno = google_compute_network.nihonmachi_vpc01.name
  }
  network = each.value

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = var.allowed_vpn_cidrs
  target_tags   = ["nihonmachi-app"]
}

# Explanation: Allow internal health checks (ILB) to reach instances.
resource "google_compute_firewall" "nihonmachi_allow_hc01" {
  name    = "nihonmachi-allow-hc01"
  network = google_compute_network.nihonmachi_vpc01.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  # GCP health check ranges (students can keep this as-is; instructor can provide exact ranges later if desired)
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["nihonmachi-app"]
}

# Load Balancer for Google Compute Instances
# This is for health checking the instances in the MIG, it is attached to the ??????????
resource "google_compute_region_health_check" "hc" {
  name   = "app-hc"
  region = var.gcp_region

  https_health_check {
    port_specification = "USE_SERVING_PORT"
    request_path       = "/"
  }
}


# This is the backbone of the Load Balancer
resource "google_compute_region_backend_service" "backend" {
  name                  = "app-backend"
  region                = var.gcp_region
  protocol              = "HTTPS"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_name             = "https"
  health_checks         = [google_compute_region_health_check.hc.id]

  backend {
    group = google_compute_region_instance_group_manager.nihonmachi_mig01.instance_group
    max_utilization = 0.8
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
  depends_on = [ google_compute_region_instance_group_manager.nihonmachi_mig01 ]
}

resource "google_compute_region_url_map" "urlmap" {
  name            = "app-urlmap"
  region          = var.gcp_region
  default_service = google_compute_region_backend_service.backend.id
}

resource "google_compute_region_ssl_certificate" "nihonmachi_cert01" {
  name   = "nihonmachi-cert01"
  region = var.gcp_region

  private_key = file("${path.module}/hidden_domain/privkey.pem")
  certificate = file("${path.module}/hidden_domain/fullchain.pem")
}

# # For simplicity, the instances terminate TLS themselves (Nginx on VM).
# # ILB can be configured with certs too, but that’s "Lab 4A-3".
resource "google_compute_region_target_https_proxy" "nihonmachi_httpsproxy01" {
  name    = "nihonmachi-httpsproxy01"
  region  = var.gcp_region
  url_map = google_compute_region_url_map.urlmap.id
  ssl_certificates = [google_compute_region_ssl_certificate.nihonmachi_cert01.id]
}



# Private forwarding rule (internal IP)
resource "google_compute_forwarding_rule" "nihonmachi_fr01" {
  name                  = "nihonmachi-fr01"
  region                = var.gcp_region
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "443"
  network               = google_compute_network.nihonmachi_vpc01.id
  subnetwork            = google_compute_subnetwork.nihonmachi_subnet01.id 
  target                = google_compute_region_target_https_proxy.nihonmachi_httpsproxy01.id
}

#########################################                SECRETS MANAGER GCP
# Explanation: Chewbacca grants only what’s needed—this VM can read ONE secret, not the whole galaxy.
resource "google_service_account" "nihonmachi_sa01" {
  account_id   = "nihonmachi-sa01"
  display_name = "nihonmachi-sa01"
}

# # # Allow reading secrets
resource "google_project_iam_member" "nihonmachi_secret_accessor01" {
  project = var.gcp_project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.nihonmachi_sa01.email}"
}


# Explanation: Chewbacca dislikes public IPs; Cloud NAT lets VMs update safely without exposing services.
variable "enable_router" {
  description = "Enable the GCP router and NAT"
  type        = bool
  default     = true
}

resource "google_compute_router" "gcp-to-aws-cloud-router" {
  count = var.enable_router ? 1 : 0
  name    = "nihonmachi-router01"
  region  = var.gcp_region
  network = google_compute_network.nihonmachi_vpc01.id
  bgp {
    asn               = 65000
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
    advertised_ip_ranges {
      range = google_compute_subnetwork.nihonmachi_subnet01.ip_cidr_range
    }
  }
}


# Nat gateway for private instances
resource "google_compute_router_nat" "nihonmachi_nat01" {
  name                               = "nihonmachi-nat01"
  router                             = google_compute_router.gcp-to-aws-cloud-router[0].name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Managed Instance Group and Instance Template for Compute Instances

locals {
  startup_script = templatefile("${path.module}/startup.sh.tftpl", {
    TOKYO_RDS_HOST = try(data.terraform_remote_state.japan[0].outputs.db_hostname, "not-created-yet")
    TOKYO_RDS_PORT = try(data.terraform_remote_state.japan[0].outputs.db_port, "not-created-yet")
    TOKYO_RDS_USER = try(data.terraform_remote_state.japan[0].outputs.db_username, "not-created-yet")
    SECRET_NAME    = try(data.terraform_remote_state.japan[0].outputs.secret_name, "not-created-yet")
    DB_PASS        = try(data.terraform_remote_state.japan[0].outputs.db_password, "not-created-yet")
  })
}
# # Explanation: Chewbacca clones disciplined soldiers—MIG gives you controlled, replaceable compute.
resource "google_compute_instance_template" "nihonmachi_tpl01" {
  name_prefix  = "nihonmachi-tpl01-"
  machine_type = "e2-medium"
  tags         = ["nihonmachi-app"]


  # service_account {
  #   email  = google_service_account.nihonmachi_sa01.email
  #   scopes = ["cloud-platform"]
  # }

  disk {
    source_image = "projects/debian-cloud/global/images/family/debian-12"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.nihonmachi_subnet01.id
    # No external IP (private-only)
  }

  metadata = {
    startup-script = local.startup_script
  }
}



# # Explanation: Nihonmachi MIG scales staff demand without creating new databases or new compliance nightmares.
resource "google_compute_region_instance_group_manager" "nihonmachi_mig01" {
  name   = "nihonmachi-mig01"
  region = var.gcp_region
  named_port {
    name = "https"
    port = 443
  }


  version {
    instance_template = google_compute_instance_template.nihonmachi_tpl01.id
  }
  
  base_instance_name = "nihonmachi-app"
  # target_size        = 2

  auto_healing_policies {
    health_check      = google_compute_region_health_check.hc.id
    initial_delay_sec = 300
  }
}
# Auto Scaling for the MIG
resource "google_compute_region_autoscaler" "foobar" {
  name   = "my-region-autoscaler"
  region = var.gcp_region
  target = google_compute_region_instance_group_manager.nihonmachi_mig01.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.7
    }
  }
}

#####################################################################################################################################
#                                               VPN CONNECTION TO AWS
#####################################################################################################################################

###############################################                    First Workflow
# GCP Cloud Router
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router

variable "first_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = true
}
# GCP HA VPN Gateway
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ha_vpn_gateway
resource "google_compute_ha_vpn_gateway" "gcp-to-aws-vpn-gw" {
  count   = var.first_workflow_enabled ? 1 : 0
  name    = "gcp-to-aws-vpn-gw"
  region  = var.gcp_region
  network = google_compute_network.nihonmachi_vpc01.id
}

###############################################                    Second Workflow

variable "second_workflow_enabled" {
  description = "Enable when the other transit gateway is created"
  type        = bool
  default     = true
}
# GCP External VPN Gateway
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_external_vpn_gateway

resource "google_compute_external_vpn_gateway" "gcp-to-aws-vpn-gw" {
  count           = var.second_workflow_enabled ? 1 : 0
  name            = "gcp-to-aws-vpn-gw"
  redundancy_type = "FOUR_IPS_REDUNDANCY"

  interface {
    id         = 0
    ip_address = local.aws-tunnel1-address-vpn1
  }

  interface {
    id         = 1
    ip_address = local.aws-tunnel2-address-vpn1
  }

  interface {
    id         = 2
    ip_address = local.aws-tunnel1-address-vpn2
  }

  interface {
    id         = 3
    ip_address = local.aws-tunnel2-address-vpn2
  }
}



# GCP VPN Tunnels
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_vpn_tunnel

# External Tunnel IPS

# Tunnel 0
resource "google_compute_vpn_tunnel" "tunnel0" {
  count                           = var.second_workflow_enabled ? 1 : 0
  name                            = "tunnel0"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  peer_external_gateway_interface = 0
  shared_secret                   = local.tunnel1_psk1 # Replace with your pre-shared key 1
  router                          = google_compute_router.gcp-to-aws-cloud-router[0].name
  ike_version                     = 2

}

# Tunnel 1
resource "google_compute_vpn_tunnel" "tunnel1" {
  count                           = var.second_workflow_enabled ? 1 : 0
  name                            = "tunnel1"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  peer_external_gateway_interface = 1
  shared_secret                   = local.tunnel1_psk2 # Replace with your pre-shared key 2
  router                          = google_compute_router.gcp-to-aws-cloud-router[0].name
  ike_version                     = 2
}

# Tunnel 2
resource "google_compute_vpn_tunnel" "tunnel2" {
  count                           = var.second_workflow_enabled ? 1 : 0
  name                            = "tunnel2"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  peer_external_gateway_interface = 2
  shared_secret                   = local.tunnel1_psk3 # Replace with your pre-shared key 3
  router                          = google_compute_router.gcp-to-aws-cloud-router[0].name
  ike_version                     = 2
}

# Tunnel 3
resource "google_compute_vpn_tunnel" "tunnel3" {
  count                           = var.second_workflow_enabled ? 1 : 0
  name                            = "tunnel3"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.gcp-to-aws-vpn-gw[0].id
  peer_external_gateway_interface = 3
  shared_secret                   = local.tunnel1_psk4 # Replace with your pre-shared key 4
  router                          = google_compute_router.gcp-to-aws-cloud-router[0].name
  ike_version                     = 2
}

# GCP Router Interface and Peer Connection
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_interface
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_peer



#Internal Tunnel IPs

# Tunnel 0
resource "google_compute_router_interface" "gcp-router-interface-tunnel0" {
  count    = var.second_workflow_enabled ? 1 : 0
  name     = "gcp-router-interface-tunnel0"
  router   = google_compute_router.gcp-to-aws-cloud-router[0].name
  region   = var.gcp_region
  ip_range = "${cidrhost(local.internal1-cidr1, 2)}/30"


  vpn_tunnel = google_compute_vpn_tunnel.tunnel0[0].name
}

resource "google_compute_router_peer" "gcp-router-peer-tunnel0" {
  count                     = var.second_workflow_enabled ? 1 : 0
  name                      = "gcp-router-peer-tunnel0"
  router                    = google_compute_router.gcp-to-aws-cloud-router[0].name
  region                    = var.gcp_region
  peer_ip_address           = cidrhost(local.internal1-cidr1, 1)
  peer_asn                  = local.aws-asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.gcp-router-interface-tunnel0[0].name
}

# Tunnel 1
resource "google_compute_router_interface" "gcp-router-interface-tunnel1" {
  count      = var.second_workflow_enabled ? 1 : 0
  name       = "gcp-router-interface-tunnel1"
  router     = google_compute_router.gcp-to-aws-cloud-router[0].name
  region     = var.gcp_region
  ip_range   = "${cidrhost(local.internal1-cidr2, 2)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1[0].name
}

resource "google_compute_router_peer" "gcp-router-peer-tunnel1" {
  count                     = var.second_workflow_enabled ? 1 : 0
  name                      = "gcp-router-peer-tunnel1"
  router                    = google_compute_router.gcp-to-aws-cloud-router[0].name
  region                    = var.gcp_region
  peer_ip_address           = cidrhost(local.internal1-cidr2, 1)
  peer_asn                  = local.aws-asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.gcp-router-interface-tunnel1[0].name
}

# Tunnel 2
resource "google_compute_router_interface" "gcp-router-interface-tunnel2" {
  count      = var.second_workflow_enabled ? 1 : 0
  name       = "gcp-router-interface-tunnel2"
  router     = google_compute_router.gcp-to-aws-cloud-router[0].name
  region     = var.gcp_region
  ip_range   = "${cidrhost(local.internal2-cidr1, 2)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2[0].name
}

resource "google_compute_router_peer" "gcp-router-peer-tunnel2" {
  count                     = var.second_workflow_enabled ? 1 : 0
  name                      = "gcp-router-peer-tunnel2"
  router                    = google_compute_router.gcp-to-aws-cloud-router[0].name
  region                    = var.gcp_region
  peer_ip_address           = cidrhost(local.internal2-cidr1, 1)
  peer_asn                  = local.aws-asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.gcp-router-interface-tunnel2[0].name
}

# Tunnel 3
resource "google_compute_router_interface" "gcp-router-interface-tunnel3" {
  count      = var.second_workflow_enabled ? 1 : 0
  name       = "gcp-router-interface-tunnel3"
  router     = google_compute_router.gcp-to-aws-cloud-router[0].name
  region     = var.gcp_region
  ip_range   = "${cidrhost(local.internal2-cidr2, 2)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel3[0].name
}

resource "google_compute_router_peer" "gcp-router-peer-tunnel3" {
  count                     = var.second_workflow_enabled ? 1 : 0
  name                      = "gcp-router-peer-tunnel3"
  router                    = google_compute_router.gcp-to-aws-cloud-router[0].name
  region                    = var.gcp_region
  peer_ip_address           = cidrhost(local.internal2-cidr2, 1)
  peer_asn                  = local.aws-asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.gcp-router-interface-tunnel3[0].name
}





resource "google_compute_firewall" "nihonmachi_allow_ssh_from_vpn02" {
  name = "nihonmachi-allow-ssh-from-vpn02"
  for_each = {
    uno = google_compute_network.nihonmachi_vpc01.name
  }
  network = each.value
  priority = 100 
  
  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["test"]
}