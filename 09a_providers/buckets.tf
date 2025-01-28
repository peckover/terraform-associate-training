resource "aws_s3_bucket" "this" {
  bucket = "jp-terraform-bucket-01-25"
  tags = {
    Name = "mybucket"
  }
}
