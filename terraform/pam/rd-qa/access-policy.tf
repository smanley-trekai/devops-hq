# IAP addition applied 2026-11-16; AVAILABLE and all ten settings verified at 16:57 UTC.
# Same project-only pattern as Dev; no contractor grant was requested.
locals {
  project_id = "prj-trekai-rd-qa"

  terraform_builder_entitlement = {
    entitlement_id       = "pam-rd-qa-terraform-builder"
    max_duration_seconds = 28800
    eligible_principals = [
      "user:contractor-ait-boopathin@trekai.org",
      "user:contractor-amplifi-jsilva@trekai.org",
    ]

    # Dev's original sixteen roles plus IAP-secured Tunnel User. IAM can
    # create access that persists beyond a PAM grant's expiry.
    roles = [
      "roles/artifactregistry.admin",
      "roles/cloudsql.admin",
      "roles/compute.admin",
      "roles/container.admin",
      "roles/dns.admin",
      "roles/iam.roleAdmin",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
      "roles/iam.workloadIdentityPoolAdmin",
      "roles/iap.tunnelResourceAccessor",
      "roles/monitoring.notificationChannelEditor",
      "roles/redis.admin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/secretmanager.admin",
      "roles/servicenetworking.networksAdmin",
      "roles/serviceusage.serviceUsageAdmin",
      "roles/storage.admin",
    ]
  }
}
