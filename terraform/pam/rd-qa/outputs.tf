output "entitlement_name" {
  description = "Full resource name of the QA project Terraform-builder entitlement."
  value       = google_privileged_access_manager_entitlement.terraform_builder.id
}
