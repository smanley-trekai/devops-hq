variable "folder_id" {
  description = "Numeric Google Cloud folder ID; access is inherited by descendant projects."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.folder_id))
    error_message = "folder_id must contain only digits."
  }
}

variable "entitlement_id" {
  description = "PAM entitlement ID, unique within the folder and location."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{3,62}$", var.entitlement_id))
    error_message = "entitlement_id must be 4–63 characters, start with a lowercase letter, and contain only lowercase letters, digits, or hyphens."
  }
}

variable "max_duration_seconds" {
  description = "Maximum grant duration in seconds; a requester may request less."
  type        = number

  validation {
    condition     = var.max_duration_seconds >= 1800 && var.max_duration_seconds <= 604800 && floor(var.max_duration_seconds) == var.max_duration_seconds
    error_message = "max_duration_seconds must be a whole number from 1800 through 604800."
  }
}

variable "eligible_principals" {
  description = "Non-empty list of requester principal identifiers for this entitlement."
  type        = list(string)

  validation {
    condition     = length(var.eligible_principals) > 0 && alltrue([for principal in var.eligible_principals : length(trimspace(principal)) > 0])
    error_message = "Provide at least one non-empty eligible principal."
  }
}

variable "approver_principals" {
  description = "Non-empty list of approver principal identifiers; one approval is required."
  type        = list(string)

  validation {
    condition     = length(var.approver_principals) > 0 && alltrue([for principal in var.approver_principals : length(trimspace(principal)) > 0])
    error_message = "Provide at least one non-empty approver principal."
  }
}
