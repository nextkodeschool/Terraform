variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ec2_sg" {
  description = "EC2 security group ID"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
