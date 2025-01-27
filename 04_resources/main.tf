resource "local_file" "file01" {
    filename = "file01.txt"
    content = "This is file01.txt"

    lifecycle {
        prevent_destroy = true //Changes to this do not need to be applied to impact destroy actions
    }
}