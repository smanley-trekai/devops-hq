# This narrowly scoped module always uses one manual approval, requires both
# justifications and grants the caller's roles on a folder. Do not change these
# controls without reviewing every root that calls this module.
resource "google_privileged_access_manager_entitlement" "this" {
  entitlement_id       = var.entitlement_id
  parent               = "folders/${var.folder_id}"
  location             = "global"
  max_request_duration = "${var.max_duration_seconds}s"

  eligible_users {
    principals = var.eligible_principals
  }

  privileged_access {
    gcp_iam_access {
      resource      = "//cloudresourcemanager.googleapis.com/folders/${var.folder_id}"
      resource_type = "cloudresourcemanager.googleapis.com/Folder"

      dynamic "role_bindings" {
        for_each = toset(var.roles)
        content {
          role = role_bindings.value
        }
      }
    }
  }

  requester_justification_config {
    unstructured {}
  }

  approval_workflow {
    manual_approvals {
      require_approver_justification = true
      steps {
        approvals_needed = 1
        approvers {
          principals = var.approver_principals
        }
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
