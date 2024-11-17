terraform {
  required_providers {
    twingate = {
      source  = "twingate/twingate"
      version = "3.0.12"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.11.2"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "twingate" {
  api_token = var.twingate_token
  network   = var.tg_network
}