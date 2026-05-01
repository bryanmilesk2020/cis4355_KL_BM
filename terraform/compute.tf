# =============================================================
# compute.tf — cis4355-bm-kl
# =============================================================

resource "google_compute_instance" "backend_vm" {
  name         = "instance-20260329-195525"
  zone         = "us-south1-c"
  machine_type = "e2-micro"

  tags = ["backend-server"]

  labels = {
    goog-ops-agent-policy = "v2-template-1-7-0"
  }

  boot_disk {
    auto_delete = true
    device_name = "instance-20260329-195525"

    initialize_params {
      image = "debian-cloud/debian-12-bookworm"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = "cis4355-project-vpc"
    subnetwork = "sn-private-backend"
    network_ip = "10.0.2.2"
    # No external IP — access via IAP only
  }

  service_account {
    email  = "web-app-backend-sa@cis4355-bm-kl.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    disable-legacy-endpoints = "TRUE"
    enable-osconfig          = "TRUE"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  can_ip_forward = false

  deletion_protection = false
}
