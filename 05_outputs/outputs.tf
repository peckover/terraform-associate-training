output "example_file_id" {
    description = "The ID of the example file"
    value = local_file.example.id
}

output "example_file_content" {
    description = "The content of the example file"
    value = local_file.example.content
    sensitive = true
}