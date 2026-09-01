terraform {
  backend "s3" {
    bucket = "terraaform-iac-july26"
    key    = "exercise6/terraform.tfstate"
    region = "us-east-1"
  }
}