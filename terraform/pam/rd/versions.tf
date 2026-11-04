terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Keep PAM state separate from bootstrap and other Terraform roots.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "pam/rd-folder"
  }
}

provider "google" {
  # A quota project may be needed for folder-scoped PAM operations.
  # Set credentials and project using the approved execution environment.
}
