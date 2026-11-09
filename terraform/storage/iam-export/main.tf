# Applied 2026-11-06. Project, location and manual cleanup were user-selected.
# Direct reader membership was verified; effective inherited access remains open.
locals {
  project_id  = "smanley-experimental"
  location    = "us-central1"
  bucket_name = "trekai-iam-export-smanley-experimental"
}

resource "google_storage_bucket" "iam_export" {
  name                        = local.bucket_name
  project                     = local.project_id
  location                    = local.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  labels = {
    managed_by = "terraform"
    purpose    = "iam-export"
  }

  versioning {
    enabled = false
  }

  # Recovery after an approved manual deletion; live exports do not expire.
  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  # No lifecycle deletion rule, bucket retention policy or CMEK configuration.
  # Cloud Asset export does not support bucket retention policies or CMEK.
  lifecycle {
    prevent_destroy = true
  }
}

# Member-level IAM preserves other bindings, including service-managed access.
resource "google_storage_bucket_iam_member" "export_reader" {
  for_each = local.export_reader_principals

  bucket = google_storage_bucket.iam_export.name
  role   = local.export_reader_role
  member = each.value
}
