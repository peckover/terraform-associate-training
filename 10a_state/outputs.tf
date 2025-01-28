output "aws_ami_arn" {
  value       = data.aws_ami.centos_9_latest.arn
  description = "The ARN of the latest official Centos 9 AMI"
}
