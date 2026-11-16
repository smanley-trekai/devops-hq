# Applied 2026-11-16: folder/project ACTIVE, parent chain and billing verified.
# See the guide for the consumed plan, verified IDs and execution record.
locals {
  organization_id     = "470598084059"
  folder_display_name = "trekai-rd-qa"
  project_id          = "prj-trekai-rd-qa"
  billing_account_id  = "018378-808B11-17982B"
}

resource "google_folder" "rd_qa" {
  display_name        = local.folder_display_name
  parent              = "organizations/${local.organization_id}"
  deletion_protection = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project" "rd_qa" {
  provider = google.project_creator

  name            = local.project_id
  project_id      = local.project_id
  folder_id       = google_folder.rd_qa.folder_id
  billing_account = local.billing_account_id
  deletion_policy = "PREVENT"

  # Retain the reviewed RD Dev setting. Actual default-network behavior depends
  # on Google policies; this draft does not guarantee a network-free project.
  auto_create_network = true

  labels = {
    environment = "qa"
    managed_by  = "terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}
