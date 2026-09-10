resource "aws_instance" "ec2" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg]

  tags = {
    Name        = "${var.instance_name}-${var.environment}"
    Environment = var.environment
  }
}
