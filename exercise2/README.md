# Exercise 2: EC2 and S3 with Variables

This exercise uses Terraform input variables to create AWS resources from a single root configuration.

It creates:

- One EC2 instance
- One S3 bucket
- Outputs for the EC2 instance ID, public IP address, and S3 bucket ID

## Directory structure

```text
exercise2/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
└── outputs.tf
```

## Terraform files

| File | Purpose |
| --- | --- |
| `provider.tf` | Configures Terraform, the AWS provider, and the AWS region. |
| `variables.tf` | Declares the input variables used by the resources. |
| `terraform.tfvars` | Supplies values for the input variables. |
| `main.tf` | Creates the EC2 instance and S3 bucket. |
| `outputs.tf` | Displays useful values after Terraform applies the configuration. |

## Resources

### EC2 instance

The EC2 instance uses values passed through variables:

```hcl
resource "aws_instance" "vm1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg]

  tags = {
    Name = var.instance_name
  }
}
```

### S3 bucket

The bucket name is also supplied through a variable. S3 bucket names must be globally unique across AWS.

```hcl
resource "aws_s3_bucket" "nks-storage" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```

## Input variables

| Variable | Description |
| --- | --- |
| `aws_region` | AWS region where the resources are created. |
| `ami_id` | AMI ID used to launch the EC2 instance. |
| `instance_type` | EC2 instance type, such as `t3.micro`. |
| `instance_name` | Value for the EC2 `Name` tag. |
| `key_name` | Name of an existing EC2 key pair. |
| `ec2_sg` | Security group ID attached to the EC2 instance. |
| `bucket_name` | Globally unique name for the S3 bucket. |

## `terraform.tfvars`

Provide values in `terraform.tfvars`. Use values that exist in your AWS account:

```hcl
aws_region    = "us-east-1"
ami_id        = "ami-xxxxxxxxxxxxxxxxx"
instance_type = "t3.micro"
instance_name = "my-terraform-instance"
key_name      = "my-key-pair"
ec2_sg        = "sg-xxxxxxxxxxxxxxxxx"
bucket_name   = "my-unique-terraform-bucket"
```

## Run the configuration

Run these commands from the `exercise2` directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Type `yes` when Terraform asks for confirmation.

## Outputs

After a successful apply, Terraform displays:

- `instance_id` — ID of the EC2 instance
- `public_ip` — public IP address of the EC2 instance
- `s3_bucket_id` — name/ID of the S3 bucket

View them again with:

```bash
terraform output
```

## Destroy resources

To avoid ongoing AWS charges, remove the resources when you no longer need them:

```bash
terraform destroy
```
