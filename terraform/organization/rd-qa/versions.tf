terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Separate state for the QA folder and project only.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "organization/rd-qa"
  }
}

provider "google" {
  # Direct smanley-adm path checked in read-only preflight, 2026-11-16.
  # Supply credentials at runtime; do not set global impersonation.
}

provider "google" {
  alias                       = "project_creator"
  impersonate_service_account = "terraform-org-admin@trekai-452018.iam.gserviceaccount.com"
}
