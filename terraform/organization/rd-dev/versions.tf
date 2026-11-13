terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Authoritative state for this folder and project only.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "organization/rd-dev"
  }
}

provider "google" {
  # Direct smanley-adm credentials for the folder. Supply credentials at runtime;
  # do not set global impersonation, which would also affect this provider.
}

provider "google" {
  alias                       = "project_creator"
  impersonate_service_account = "terraform-org-admin@trekai-452018.iam.gserviceaccount.com"
}
