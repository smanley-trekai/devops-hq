# One project-scoped entitlement. The existing reusable PAM module targets
# folders; this resource needs a project target and an IAP hostname condition.
resource "google_privileged_access_manager_entitlement" "qa_desktop_web_user" {
  entitlement_id       = local.qa_desktop_entitlement.entitlement_id
  parent               = "projects/${local.qa_project_id}"
  location             = "global"
  max_request_duration = "${local.qa_desktop_entitlement.max_duration_seconds}s"

  eligible_users {
    principals = local.qa_desktop_entitlement.eligible_principals
  }

  privileged_access {
    gcp_iam_access {
      resource      = "//cloudresourcemanager.googleapis.com/projects/${local.qa_project_id}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"

      role_bindings {
        role                 = local.qa_desktop_entitlement.role
        condition_expression = local.qa_desktop_entitlement.condition_expression
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
          principals = local.qa_desktop_entitlement.approver_principals
        }
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
