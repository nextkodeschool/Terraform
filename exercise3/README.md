# Exercise 3: Reusable Terraform Modules

This exercise uses reusable Terraform modules to deploy AWS infrastructure.

It creates:

- Two EC2 instances: `web01` and `web02`
- One S3 bucket
- An `Environment` tag on every resource
- Remote Terraform state stored in an S3 backend

## Directory structure

```text
exercise3/
├── backend.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
└── modules/
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── s3/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## How it works

The root module calls the reusable EC2 module twice and the S3 module once:

```text
Root module
├── EC2 module → web01
├── EC2 module → web02
└── S3 module  → one bucket
```

Both EC2 module calls use the same AMI, instance type, key pair, security group, and environment. Only `instance_name` changes:

```hcl
module "web01" {
  source        = "./modules/ec2"
  instance_name = "web01"
  # other variables...
}

module "web02" {
  source        = "./modules/ec2"
  instance_name = "web02"
  # other variables...
}
```

The EC2 module applies these values to its resource:

```hcl
tags = {
  Name        = var.instance_name
  Environment = var.environment
}
```

The S3 module uses `var.bucket_name` as the bucket name and applies the environment as a tag.

## Remote state

`backend.tf` stores the Terraform state in S3:

```hcl
bucket = "terraaform-iac-july26"
key    = "terraform.tfstate"
region = "us-east-1"
```

Create the backend bucket before running `terraform init`. This bucket is separate from the S3 bucket created by the `s3` module.

## Input variables

| Variable | Description |
| --- | --- |
| `aws_region` | AWS region used by the provider. |
| `environment` | Environment tag applied to the resources. |
| `ami_id` | AMI ID used by both EC2 instances. |
| `instance_type` | EC2 instance type. |
| `key_name` | Existing EC2 key pair name. |
| `ec2_sg` | Security group ID attached to both instances. |
| `bucket_name` | Globally unique name for the S3 bucket. |

Set these values in `terraform.tfvars`:

```hcl
aws_region    = "us-east-1"
environment   = "dev"
ami_id        = "ami-xxxxxxxxxxxxxxxxx"
instance_type = "t3.micro"
key_name      = "my-key-pair"
ec2_sg        = "sg-xxxxxxxxxxxxxxxxx"
bucket_name   = "my-unique-terraform-bucket"
```

## Run the configuration

Run these commands from the `exercise3` directory:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Review the plan and type `yes` when Terraform asks for confirmation.

## Outputs

After a successful apply, Terraform displays:

- Instance ID, public IP, and private IP for `web01`
- Instance ID, public IP, and private IP for `web02`
- S3 bucket ID and ARN

View the values again with:

```bash
terraform output
```

## Destroy resources

Remove the resources when they are no longer needed:

```bash
terraform destroy
```
