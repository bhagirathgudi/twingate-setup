data "twingate_remote_network" "rn" {
  name = var.remote_nw_id
}

resource "twingate_connector" "gcp_connector" {
  remote_network_id = data.twingate_remote_network.rn.id
}

resource "twingate_connector_tokens" "twingate_connector_tokens" {
  connector_id = twingate_connector.gcp_connector.id
}

resource "google_compute_network" "rn" {
  name                    = "rn"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_range
  network       = google_compute_network.rn.id
}

resource "google_compute_firewall" "default" {
  name    = "default-firewall"
  network = google_compute_network.rn.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [google_compute_subnetwork.subnet.ip_cidr_range]
}

resource "google_compute_instance" "vm_instance_connector" {
  name         = "twingate-gcp-connector"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-bionic-v20220712"
    }
  }

  network_interface {

    network    = google_compute_network.rn.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {

    }
  }
  metadata_startup_script = templatefile("${path.module}/template/twingate_client.tftpl", { accessToken = twingate_connector_tokens.twingate_connector_tokens.access_token, refreshToken = twingate_connector_tokens.twingate_connector_tokens.refresh_token, tgnetwork = var.tg_network })

}
