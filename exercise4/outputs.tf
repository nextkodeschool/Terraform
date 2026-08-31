
output "web01_instance_id" {
  description = "EC2 instance ID"
  value       = module.web01.instance_id
}

output "web01_public_ip" {
  description = "EC2 instance Public IP"
  value       = module.web01.public_ip
}

output "web01_private_ip" {
  description = "Web01 private IP"
  value       = module.web01.private_ip
}


output "web02_instance_id" {
  description = "Web02 EC2 instance ID"
  value       = module.web02.instance_id
}

output "web02_public_ip" {
  description = "Web02 public IP"
  value       = module.web02.public_ip
}

output "web02_private_ip" {
  description = "Web02 private IP"
  value       = module.web02.private_ip
}


output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3.bucket_arn
}
