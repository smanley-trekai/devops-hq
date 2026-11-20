terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "pam/hub-staging"
  }
}

provider "google" {
  # Select the approved administrative identity and quota project at runtime.
}
