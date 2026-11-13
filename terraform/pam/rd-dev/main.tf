resource "google_project_service" "pam_api" {
  project            = local.project_id
  service            = "privilegedaccessmanager.googleapis.com"
  disable_on_destroy = false
}

# Direct project resource: the shared folder module always requires approval.
resource "google_privileged_access_manager_entitlement" "terraform_builder" {
  depends_on = [google_project_service.pam_api]

  entitlement_id       = local.terraform_builder_entitlement.entitlement_id
  parent               = "projects/${local.project_id}"
  location             = "global"
  max_request_duration = "${local.terraform_builder_entitlement.max_duration_seconds}s"

  eligible_users {
    principals = local.terraform_builder_entitlement.eligible_principals
  }

  privileged_access {
    gcp_iam_access {
      resource      = "//cloudresourcemanager.googleapis.com/projects/${local.project_id}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"

      dynamic "role_bindings" {
        for_each = toset(local.terraform_builder_entitlement.roles)
        content {
          role = role_bindings.value
        }
      }
    }
  }

  requester_justification_config {
    unstructured {}
  }

  # Intentionally omit approval_workflow: eligible requests activate without
  # an approver. Requester justification and the grant time limit still apply.

  lifecycle {
    prevent_destroy = true
  }
}
