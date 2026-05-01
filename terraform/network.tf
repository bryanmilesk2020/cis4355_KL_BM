# =============================================================
# network.tf — cis4355-bm-kl
# =============================================================

# -------------------------------------------------------------
# VPC Network
# -------------------------------------------------------------
resource "google_compute_network" "vpc" {
  name                    = "cis4355-project-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# -------------------------------------------------------------
# Subnets
# -------------------------------------------------------------
resource "google_compute_subnetwork" "public_frontend" {
  name          = "sn-public-frontend"
  region        = "us-south1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_subnetwork" "private_backend" {
  name          = "sn-private-backend"
  region        = "us-south1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.2.0/24"
}

resource "google_compute_subnetwork" "private_db" {
  name          = "sn-private-db"
  region        = "us-south1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.3.0/24"
}

# Proxy-only subnet — required for regional HTTP(S) load balancer
resource "google_compute_subnetwork" "proxy_only" {
  name          = "proxy-only-subnet"
  region        = "us-south1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.128.0.0/20"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

# -------------------------------------------------------------
# Firewall Rules
# -------------------------------------------------------------

# Allow Flask port 5000 from anywhere, targeting backend VMs only
resource "google_compute_firewall" "allow_backend_port_5000" {
  name      = "allow-backend-port-5000"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["backend-server"]
}

# Allow load balancer health checks to reach Flask
resource "google_compute_firewall" "allow_lb_to_flask" {
  name      = "allow-lb-to-flask"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

# Allow backend subnet to receive MySQL traffic from backend VMs
resource "google_compute_firewall" "allow_backend_to_sql" {
  name      = "allow-backend-to-sql"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["10.0.2.0/24"]
}

# Allow backend VM egress to Cloud SQL on 3306
resource "google_compute_firewall" "allow_backend_to_sql_egress" {
  name      = "allow-backend-to-sql-egress"
  network   = google_compute_network.vpc.name
  direction = "EGRESS"
  priority  = 100

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  destination_ranges = ["10.10.0.0/20"]
}

# Allow SSH via IAP only
resource "google_compute_firewall" "allow_ssh_from_iap" {
  name      = "allow-ssh-from-iap"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

# Allow all internal traffic between the three subnets (with logging)
resource "google_compute_firewall" "allow_internal_traffic" {
  name      = "cis4355-allow-internal-traffic"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000
  description = "allow traffic between tiers"

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# Custom allow-all low priority fallback
resource "google_compute_firewall" "allow_custom" {
  name      = "cis4355-project-vpc-allow-custom"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 65534

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.0.0/8"]
}

# Allow ICMP (ping)
resource "google_compute_firewall" "allow_icmp" {
  name      = "cis4355-project-vpc-allow-icmp"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 65534

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Deny all other ingress traffic (catch-all)
resource "google_compute_firewall" "deny_all_other" {
  name      = "deny-all-other-traffic"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 2000

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# -------------------------------------------------------------
# Cloud Router + NAT Gateway
# -------------------------------------------------------------
resource "google_compute_router" "nat_router" {
  name    = "cis4355-nat-router"
  region  = "us-south1"
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "cis4355-nat-gateway"
  router                             = google_compute_router.nat_router.name
  region                             = "us-south1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# -------------------------------------------------------------
# Private Services Access (Cloud SQL VPC Peering range)
# -------------------------------------------------------------
resource "google_compute_global_address" "private_sql_range" {
  name          = "google-managed-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  address       = "10.10.0.0"
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_sql_range.name]
}

# -------------------------------------------------------------
# Static External IP (Load Balancer frontend)
# -------------------------------------------------------------
resource "google_compute_address" "lb_static_ip" {
  name   = "cis4355-lb-static-ip"
  region = "us-south1"
}
