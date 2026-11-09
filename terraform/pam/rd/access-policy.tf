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

  # Human requester switch applied and live settings verified 2026-11-09.
  # Role, duration and approvers are unchanged; see the RD guide change record.
  # Folder Admin includes IAM changes; it is not general service administration.
  rd_folder_admin_entitlement = {
    entitlement_id       = "pam-rd-folder-admin"
    roles                = ["roles/resourcemanager.folderAdmin"]
    max_duration_seconds = 28800
    # PAM elevates Jeferson's signed-in user for console and direct CLI access.
    eligible_principals = [
      "user:contractor-amplifi-jsilva@trekai.org",
    ]
    approver_principals = [
      "user:smanley@trekai.org",
      "user:pmossman@trekai.org",
    ]
  }
}
