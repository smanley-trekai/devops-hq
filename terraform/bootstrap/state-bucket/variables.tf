variable "project_id" {
  description = "Existing Google Cloud project that owns the Terraform state bucket."
  type        = string
}

variable "bucket_name" {
  description = "Globally unique Cloud Storage bucket name, selected by the owner."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Use 3–63 lowercase letters, numbers and hyphens, starting and ending with a letter or number."
  }
}

variable "location" {
  description = "Cloud Storage location permitted by the organization's current policy."
  type        = string
  default     = "us-central1"
}
