output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ec2.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.ec2.public_ip
}

output "private_ip" {
  description = "EC2 private IP"
  value       = aws_instance.ec2.private_ip
}
