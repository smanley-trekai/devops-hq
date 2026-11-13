# DOKB-984: temporary browser access to the existing QA desktop.
# Access settings are reviewable source; they contain no credentials.
locals {
  qa_project_id       = "qa-virtual-machine"
  qa_desktop_hostname = "cap-qa-desktop-ywrfwy7rba-uc.a.run.app"

  qa_desktop_entitlement = {
    entitlement_id       = "pam-qa-desktop-web-user"
    role                 = "roles/iap.httpsResourceAccessor"
    condition_expression = "request.host == ${jsonencode(local.qa_desktop_hostname)}"
    max_duration_seconds = 28800
    eligible_principals  = ["user:contractor-ait-harikarang@trekai.org"]
    approver_principals = [
      "user:smanley@trekai.org",
      "user:pmossman@trekai.org",
    ]
  }
}
