terraform {
  backend "s3" {
    bucket = "terraaform-iac-july26"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
