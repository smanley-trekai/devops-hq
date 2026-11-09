# RD-specific values belong in this reviewed root, not in hidden local tfvars.
# Folder-level Logs Viewer covers eligible logs throughout descendant projects.
locals {
  rd_folder_id = "653186815477"

  rd_logs_entitlement = {
    entitlement_id       = "pam-rd-folder-logs-viewer-ait" # existing live ID; immutable, keep
    roles                = ["roles/logging.viewer"]
    max_duration_seconds = 28800
    eligible_principals  = ["user:contractor-ait-boopathin@trekai.org"]
    approver_principals = [
      "user:smanley@trekai.org",
      "user:pmossman@trekai.org",
    ]
  }

  # Role, service-account requester and approvers approved 2026-11-09.
  # Live backend/plan/apply authorization remains separate; see the RD guide.
  # Folder Admin includes IAM changes; it is not general service administration.
  rd_folder_admin_entitlement = {
    entitlement_id       = "pam-rd-folder-admin"
    roles                = ["roles/resourcemanager.folderAdmin"]
    max_duration_seconds = 28800
    # PAM elevates the impersonated service account that submits the request.
    eligible_principals = [
      "serviceAccount:sa-jeferson-amplifi01@trekai-ws-app-mgmt-452018.iam.gserviceaccount.com",
    ]
    approver_principals = [
      "user:smanley@trekai.org",
      "user:pmossman@trekai.org",
    ]
  }
}
