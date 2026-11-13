# Applied 2026-11-13: folder/project ACTIVE and billing enabled; see guide.
locals {
  organization_id     = "470598084059"
  folder_display_name = "trekai-rd-dev"
  project_id          = "prj-trekai-rd-dev"
  billing_account_id  = "018378-808B11-17982B"
}

resource "google_folder" "rd_dev" {
  display_name        = local.folder_display_name
  parent              = "organizations/${local.organization_id}"
  deletion_protection = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project" "rd_dev" {
  provider = google.project_creator

  name            = local.project_id
  project_id      = local.project_id
  folder_id       = google_folder.rd_dev.folder_id
  billing_account = local.billing_account_id
  deletion_policy = "PREVENT"

  # Keep Google's policy-controlled default behavior. Setting false would enable
  # Compute Engine and delete the generated default network (outside this draft).
  auto_create_network = true

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}
