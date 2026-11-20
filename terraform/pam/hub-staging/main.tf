# API administration only. This does not grant access to organization Terraform
# state or authorize other Hub roots, production, or service-account impersonation.
module "hub_staging_api_admin" {
  source = "../../modules/pam-folder-entitlement"

  folder_id            = local.hub_staging_folder_id
  entitlement_id       = local.hub_staging_api_entitlement.entitlement_id
  roles                = local.hub_staging_api_entitlement.roles
  max_duration_seconds = local.hub_staging_api_entitlement.max_duration_seconds
  eligible_principals  = local.hub_staging_api_entitlement.eligible_principals
  approver_principals  = local.hub_staging_api_entitlement.approver_principals
}
