resource "local_file" "lab07" {
    filename = var.filename
    content = "terraform created file"  
}