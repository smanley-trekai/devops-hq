output "bucket_name" {
  description = "Name of the dedicated IAM-export bucket after an approved deployment."
  value       = google_storage_bucket.iam_export.name
}

output "bucket_uri" {
  description = "Cloud Storage URI for separately approved IAM export operations."
  value       = "gs://${google_storage_bucket.iam_export.name}"
}
