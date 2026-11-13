output "folder_id" {
  description = "Numeric ID of the new trekai-rd-dev folder."
  value       = google_folder.rd_dev.folder_id
}

output "folder_name" {
  description = "Resource name of the new folder, in folders/ID form."
  value       = google_folder.rd_dev.name
}

output "project_id" {
  description = "ID of the new project inside trekai-rd-dev."
  value       = google_project.rd_dev.project_id
}

output "project_number" {
  description = "Google-assigned number of the new project."
  value       = google_project.rd_dev.number
}
