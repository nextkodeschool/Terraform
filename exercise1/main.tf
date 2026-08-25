terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "vm1" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  key_name      = "ecs-vm-key" 
  vpc_security_group_ids = ["sg-02eebdc31e2f8ad66"]

  tags = {
    Name = "Terraform-IaC"
  }
}


