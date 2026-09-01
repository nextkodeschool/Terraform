variable "instance_type" {
  type        = string
  description = "The size of the virtual machine instance."
}

variable "aws_region" {
  description = "AWS region where EC2 will be created"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ec2_sg" {
  description = "EC2 SG"
  type        = string
}

variable "bucket_name" {
  description = "Base name of the original S3 bucket"
  type        = string
}

variable "bucket2_name" {
  description = "Base name of the second S3 bucket to import"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}
