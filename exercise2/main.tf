
resource "aws_instance" "vm1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_s3_bucket" "nks-storage" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


