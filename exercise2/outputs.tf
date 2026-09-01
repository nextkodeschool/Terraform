
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.vm1.id
}

output "public_ip" {
  description = "EC2 instance Public IP"
  value       = aws_instance.vm1.public_ip
}

output "s3_bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.nks-storage.id
}
