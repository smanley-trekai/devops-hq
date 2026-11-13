output "bucket_name" {
  description = "Dedicated bucket for the contractors' RD development environment state."
  value       = google_storage_bucket.environment_state.name
}

output "bucket_url" {
  description = "Cloud Storage URL of the dedicated environment state bucket."
  value       = google_storage_bucket.environment_state.url
}
