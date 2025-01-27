resource "local_file" "hello" {
    filename = "hello.txt"
    content = "hello world!"
}