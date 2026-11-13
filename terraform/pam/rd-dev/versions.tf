terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Administrative state for the entitlement, separate from contractor state.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "pam/rd-dev"
  }
}

provider "google" {
  project = local.project_id
  # Select the separately approved administrative caller/quota project at runtime.
}
