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
}
