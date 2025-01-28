output "buckets" {
  description = "Buckets for me"
  value       = data.aws_s3_bucket.my_bucket.arn
}
