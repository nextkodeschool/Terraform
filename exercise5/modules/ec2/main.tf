resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg]

  # Executes website.sh when the instance starts during terraform apply.
  user_data                   = file("${path.module}/website.sh")
  user_data_replace_on_change = true

  tags = {
    Name        = "${var.instance_name}-${var.environment}"
    Environment = var.environment
  }
}
