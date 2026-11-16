output "folder_id" {
  description = "Numeric ID of the new trekai-rd-qa folder."
  value       = google_folder.rd_qa.folder_id
}

output "folder_name" {
  description = "Resource name of the new folder, in folders/ID form."
  value       = google_folder.rd_qa.name
}

output "project_id" {
  description = "ID of the new project inside trekai-rd-qa."
  value       = google_project.rd_qa.project_id
}

output "project_number" {
  description = "Google-assigned number of the new project."
  value       = google_project.rd_qa.number
}
