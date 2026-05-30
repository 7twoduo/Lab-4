# Providers
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }

  backend "local" {
    path = "secrets/terraform.tfstate"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

############################################################
# VPC + Private Subnet
############################################################

resource "google_compute_network" "nihonmachi_vpc01" {
  name                    = "nihonmachi-vpc01"
  auto_create_subnetworks = false

  # Keep regional routing unless you explicitly need GLOBAL for your VPN design.
  # routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "nihonmachi_subnet01" {
  name                     = "nihonmachi-subnet01"
  ip_cidr_range            = var.nihonmachi_subnet_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.nihonmachi_vpc01.id
  private_ip_google_access = true
}

############################################################
# Proxy-Only Subnet for Regional External Application LB
############################################################

resource "google_compute_subnetwork" "nihonmachi_proxy_only_uscentral1" {
  name          = "nihonmachi-proxy-only-uscentral1"
  region        = var.gcp_region
  network       = google_compute_network.nihonmachi_vpc01.id
  ip_cidr_range = "10.250.200.0/24"

  purpose = "REGIONAL_MANAGED_PROXY"
  role    = "ACTIVE"
}

############################################################
# Firewall Rules
############################################################

# Allows the regional external HTTP load balancer proxy subnet to reach
# the private instances on port 80.
resource "google_compute_firewall" "nihonmachi_allow_http_from_lb_proxy01" {
  name    = "nihonmachi-allow-http-from-lb-proxy01"
  network = google_compute_network.nihonmachi_vpc01.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    google_compute_subnetwork.nihonmachi_proxy_only_uscentral1.ip_cidr_range
  ]

  target_tags = ["nihonmachi-app"]
}

# Allows Google health checks to reach the private instances on port 80.
resource "google_compute_firewall" "nihonmachi_allow_http_hc01" {
  name    = "nihonmachi-allow-http-hc01"
  network = google_compute_network.nihonmachi_vpc01.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]

  target_tags = ["nihonmachi-app"]
}

# Keeps VPN/BGP private-path testing available from AWS/on-prem CIDRs.
# This lets private CIDRs in var.allowed_vpn_cidrs reach the app directly on HTTP.
resource "google_compute_firewall" "nihonmachi_allow_http_from_vpn01" {
  name    = "nihonmachi-allow-http-from-vpn01"
  network = google_compute_network.nihonmachi_vpc01.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = var.allowed_vpn_cidrs
  target_tags   = ["nihonmachi-app"]
}

# Optional: keeping your original VPN database-style rule close to the original.
# Remove this if nothing in GCP should receive inbound MySQL from the VPN.
resource "google_compute_firewall" "nihonmachi_allow_mysql_from_vpn01" {
  name    = "nihonmachi-allow-mysql-from-vpn01"
  network = google_compute_network.nihonmachi_vpc01.name

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = var.allowed_vpn_cidrs
  target_tags   = ["nihonmachi-app"]
}

# Allows SSH from anywhere.
# This is open to the internet, so only use it for quick testing.
resource "google_compute_firewall" "nihonmachi_allow_ssh_from_everywhere01" {
  name    = "nihonmachi-allow-ssh-from-everywhere01"
  network = google_compute_network.nihonmachi_vpc01.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = ["nihonmachi-app"]
}

############################################################
# Regional HTTP Health Check
############################################################

resource "google_compute_region_health_check" "hc" {
  name   = "app-hc"
  region = var.gcp_region

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port_specification = "USE_SERVING_PORT"
    request_path       = "/health"
  }
}

############################################################
# Regional External HTTP Load Balancer
############################################################

resource "google_compute_region_backend_service" "backend" {
  name                  = "app-backend"
  region                = var.gcp_region
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_name             = "http"
  health_checks         = [google_compute_region_health_check.hc.id]

  backend {
    group           = google_compute_region_instance_group_manager.nihonmachi_mig01.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }

  depends_on = [
    google_compute_region_instance_group_manager.nihonmachi_mig01
  ]
}

resource "google_compute_region_url_map" "urlmap" {
  name            = "app-urlmap"
  region          = var.gcp_region
  default_service = google_compute_region_backend_service.backend.id
}

resource "google_compute_region_target_http_proxy" "nihonmachi_httpproxy01" {
  name    = "nihonmachi-httpproxy01"
  region  = var.gcp_region
  url_map = google_compute_region_url_map.urlmap.id
}

resource "google_compute_address" "nihonmachi_lb_ip01" {
  name         = "nihonmachi-lb-ip01"
  region       = var.gcp_region
  address_type = "EXTERNAL"
}

resource "google_compute_forwarding_rule" "nihonmachi_fr01" {
  name                  = "nihonmachi-fr01"
  region                = var.gcp_region
  load_balancing_scheme = "EXTERNAL_MANAGED"

  ip_protocol = "TCP"
  port_range  = "80"
  ip_address  = google_compute_address.nihonmachi_lb_ip01.id

  network = google_compute_network.nihonmachi_vpc01.id
  target  = google_compute_region_target_http_proxy.nihonmachi_httpproxy01.id

  depends_on = [
    google_compute_subnetwork.nihonmachi_proxy_only_uscentral1
  ]
}

############################################################
# Service Account + Secret Access
############################################################

resource "google_service_account" "nihonmachi_sa01" {
  account_id   = "nihonmachi-sa01"
  display_name = "nihonmachi-sa01"
}

resource "google_project_iam_member" "nihonmachi_secret_accessor01" {
  project = var.gcp_project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.nihonmachi_sa01.email}"
}

############################################################
# Cloud Router + NAT
############################################################

# GCP Cloud Router
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
#
# This router is needed by the HA VPN/BGP code below.
# Your HA VPN section already references:
# google_compute_router.gcp-to-aws-cloud-router[0].name
#
# So this resource needs count = 1 to keep that [0] reference valid.
resource "google_compute_router" "gcp-to-aws-cloud-router" {
  count = 1

  name    = "nihonmachi-router01"
  region  = var.gcp_region
  network = google_compute_network.nihonmachi_vpc01.id

  bgp {
    asn               = 65000
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]

    # Advertise the GCP private subnet to AWS over BGP.
    advertised_ip_ranges {
      range = google_compute_subnetwork.nihonmachi_subnet01.ip_cidr_range
    }
  }
}

# Explanation: Chewbacca dislikes public IPs; Cloud NAT lets private VMs update safely
# without exposing the VM directly to the internet.
resource "google_compute_router_nat" "nihonmachi_nat01" {
  name                               = "nihonmachi-nat01"
  router                             = google_compute_router.gcp-to-aws-cloud-router[0].name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

############################################################
# Private Instance Template
############################################################

resource "google_compute_instance_template" "nihonmachi_tpl01" {
  name_prefix  = "nihonmachi-tpl01-"
  machine_type = "e2-medium"
  tags         = ["nihonmachi-app"]

  service_account {
    email  = google_service_account.nihonmachi_sa01.email
    scopes = ["cloud-platform"]
  }

  disk {
    source_image = "projects/debian-cloud/global/images/family/debian-12"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.nihonmachi_subnet01.id

    # No access_config block.
    # This keeps the VM private-only with no public IP.
  }

  metadata = {
    startup-script = local.startup_script
  }

  lifecycle {
    create_before_destroy = true
  }
}

############################################################
# Regional Managed Instance Group
############################################################

resource "google_compute_region_instance_group_manager" "nihonmachi_mig01" {
  name   = "nihonmachi-mig01"
  region = var.gcp_region

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.nihonmachi_tpl01.id
  }

  base_instance_name = "nihonmachi-app"

  auto_healing_policies {
    health_check      = google_compute_region_health_check.hc.id
    initial_delay_sec = 300
  }
}

############################################################
# Autoscaler
############################################################

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
# Workflow Uno
# GCP HA VPN Gateway
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ha_vpn_gateway
resource "google_compute_ha_vpn_gateway" "gcp-to-aws-vpn-gw" {
  count   = var.first_workflow_enabled ? 1 : 0
  name    = "gcp-to-aws-vpn-gw"
  region  = var.gcp_region
  network = google_compute_network.nihonmachi_vpc01.id
}

###############################################                    Second Workflow
# Workflow Dos
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