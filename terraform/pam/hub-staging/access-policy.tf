# Applied 2026-11-20; AVAILABLE and all eleven settings verified at 15:58 UTC.
# No grant was requested; actual requester/access/expiry tests remain outstanding.
locals {
  hub_staging_folder_id = "777554202891"

  hub_staging_api_entitlement = {
    entitlement_id = "pam-hub-staging-service-usage-admin"
    # This predefined role can enable AND disable APIs in descendant projects.
    roles                = ["roles/serviceusage.serviceUsageAdmin"]
    max_duration_seconds = 28800
    eligible_principals  = ["user:contractor-amplifi-jsilva@trekai.org"]
    approver_principals = [
      "user:smanley@trekai.org",
      "user:pmossman@trekai.org",
    ]
  }
}
