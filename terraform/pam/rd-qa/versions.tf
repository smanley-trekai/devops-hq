terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Separate administrative state for QA PAM, not contractor workload state.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "pam/rd-qa"
  }
}

provider "google" {
  project = local.project_id
  # Select the separately approved administrative caller/quota at runtime.
}
