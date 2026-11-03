# This root manages the folder-scoped entitlement. It does not import or
# modify the existing project-scoped entitlement.
module "rd_folder_logs_viewer" {
  source = "../../modules/pam-folder-logs-viewer"

  folder_id            = local.rd_folder_id
  entitlement_id       = local.rd_logs_entitlement.entitlement_id
  max_duration_seconds = local.rd_logs_entitlement.max_duration_seconds
  eligible_principals  = local.rd_logs_entitlement.eligible_principals
  approver_principals  = local.rd_logs_entitlement.approver_principals
}
