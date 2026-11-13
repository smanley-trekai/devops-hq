# Applied 2026-11-13; AVAILABLE and all access settings live-verified at 20:03 UTC.
# No contractor grant was requested by this operation; see the access runbook.
# CAP source baseline: tl-trekcap-terraform 28f2daa, snapshot 2026-11-02.
locals {
  project_id = "prj-trekai-rd-dev"

  terraform_builder_entitlement = {
    entitlement_id       = "pam-rd-dev-terraform-builder"
    max_duration_seconds = 28800
    eligible_principals = [
      "user:contractor-ait-boopathin@trekai.org",
      "user:contractor-amplifi-jsilva@trekai.org",
    ]

    # Project-scoped service administration for the saved CAP component set.
    # IAM administration can create access that persists beyond a PAM grant.
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
