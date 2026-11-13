terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Bootstrap management stays outside the bucket this root will create.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "storage/rd-dev-state"
  }
}

provider "google" {
  project = local.project_id
  region  = local.location
  # Select the separately approved administrative caller/quota project at runtime.
}
