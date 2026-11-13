terraform {
  required_version = "= 1.17.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.22.0"
    }
  }

  # Dedicated project PAM state, separate from the existing RD folder root.
  backend "gcs" {
    bucket = "devops-hq-bucket"
    prefix = "pam/qa-desktop"
  }
}

provider "google" {
  project = local.qa_project_id
  # Supply the separately approved identity and quota project at execution time.
}
