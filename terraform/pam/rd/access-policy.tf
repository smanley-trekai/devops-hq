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

  # Jeferson and Boopathi eligibility applied and live-verified 2026-11-11.
  # Role, duration and approvers are unchanged; see the RD guide change record.
  # Folder Admin includes IAM changes; it is not general service administration.
  rd_folder_admin_entitlement = {
    entitlement_id       = "pam-rd-folder-admin"
    roles                = ["roles/resourcemanager.folderAdmin"]
    max_duration_seconds = 28800
    # PAM elevates eligible signed-in users for console and direct CLI access.
    eligible_principals = [
      "user:contractor-amplifi-jsilva@trekai.org",
      "user:contractor-ait-boopathin@trekai.org",
    ]
    approver_principals = [
      "user:smanley@trekai.org",
      "user:pmossman@trekai.org",
    ]
  }

  # Applied 2026-11-13; AVAILABLE and all access settings live-verified at 14:13 UTC.
  # Logs Viewer remains a separate entitlement; this adds the requested service roles.
  rd_observability_entitlement = {
    entitlement_id = "pam-rd-folder-observability-viewer"
    roles = [
      "roles/monitoring.viewer",
      "roles/monitoring.dashboardViewer", # overlaps Monitoring Viewer; explicitly requested
      "roles/container.viewer",
    ]
    max_duration_seconds = 28800
    eligible_principals  = ["user:contractor-ait-boopathin@trekai.org"]
    approver_principals = [
      "user:smanley@trekai.org",
      "user:pmossman@trekai.org",
    ]
  }
}
