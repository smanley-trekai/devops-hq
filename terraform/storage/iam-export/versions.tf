terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Authoritative state for the export bucket and its direct human reader.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "storage/iam-export"
  }
}

provider "google" {
  project = local.project_id
  region  = local.location
}
