output "ebs_volume_id" {
  value       = aws_ebs_volume.example.id
  description = "The ID of the EBS volume"
}

output "standard_tags" {
  value       = local.tags
  description = "Standardised tags for DPE AWS resources"
}
