# Direct reader membership verified 2026-11-06; inherited access needs review.
# Separate native, time-limited Cloud Asset writer membership is recorded in
# docs/terraform/storage/iam-export.md; this root does not own that membership.
locals {
  export_reader_principals = toset([
    "user:smanley-adm@trekai.org",
  ])
  export_reader_role = "roles/storage.objectViewer"
}
