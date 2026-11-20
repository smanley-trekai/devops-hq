output "entitlement_name" {
  description = "Full name of the Hub staging API-administration entitlement."
  value       = "folders/${local.hub_staging_folder_id}/locations/global/entitlements/${local.hub_staging_api_entitlement.entitlement_id}"
}
