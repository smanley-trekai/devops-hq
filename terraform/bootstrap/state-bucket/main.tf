# The first apply uses local state; do not deploy until the project, billing,
# account, bucket name, permissions and plan have been reviewed.
resource "google_storage_bucket" "terraform_state" {
  name                        = var.bucket_name
  project                     = var.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
