terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Bootstrap state is stored separately from other Terraform roots.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "bootstrap/state-bucket"
  }
}

provider "google" {
  project = var.project_id
  region  = var.location
}
