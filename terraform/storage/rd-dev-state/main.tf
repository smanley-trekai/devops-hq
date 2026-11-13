# Applied 2026-11-13; bucket project/location and all controls verified at 20:27 UTC.
locals {
  project_id  = "prj-trekai-rd-dev"
  bucket_name = "prj-trekai-rd-dev-tfstate"
  location    = "us-central1"
}

resource "google_project_service" "storage_api" {
  project            = local.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "google_storage_bucket" "environment_state" {
  depends_on = [google_project_service.storage_api]

  project                     = local.project_id
  name                        = local.bucket_name
  location                    = local.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  labels = {
    application = "trekcap"
    environment = "dev"
    managed_by  = "terraform"
    purpose     = "terraform-state"
  }

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  lifecycle {
    prevent_destroy = true
  }
}
