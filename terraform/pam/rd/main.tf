# This root manages folder-scoped entitlements. It does not import or
# modify the existing project-scoped entitlement.
module "rd_folder_logs_viewer" {
  source = "../../modules/pam-folder-entitlement"

  folder_id            = local.rd_folder_id
  entitlement_id       = local.rd_logs_entitlement.entitlement_id
  roles                = local.rd_logs_entitlement.roles
  max_duration_seconds = local.rd_logs_entitlement.max_duration_seconds
  eligible_principals  = local.rd_logs_entitlement.eligible_principals
  approver_principals  = local.rd_logs_entitlement.approver_principals
}

# Human requester update applied; AVAILABLE/settings verified 2026-11-09.
module "rd_folder_admin" {
  source = "../../modules/pam-folder-entitlement"

  folder_id            = local.rd_folder_id
  entitlement_id       = local.rd_folder_admin_entitlement.entitlement_id
  roles                = local.rd_folder_admin_entitlement.roles
  max_duration_seconds = local.rd_folder_admin_entitlement.max_duration_seconds
  eligible_principals  = local.rd_folder_admin_entitlement.eligible_principals
  approver_principals  = local.rd_folder_admin_entitlement.approver_principals
}
