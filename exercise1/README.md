# Exercise 1: Create an EC2 Instance

This introductory exercise uses Terraform to create one AWS EC2 instance.

All configuration is currently defined in a single file, `main.tf`.

## What this configuration creates

- An EC2 instance in `us-east-1`
- A `t3.micro` instance using the configured AMI
- An existing EC2 key pair and security group
- An EC2 `Name` tag set to `Terraform-IaC`

## Project structure

```text
exercise1/
└── main.tf
```

## Configuration overview

`main.tf` contains three parts:

```text
Terraform provider requirement
        ↓
AWS provider configuration
        ↓
EC2 instance resource
```

The EC2 resource is declared as:

```hcl
resource "aws_instance" "vm1" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  key_name               = "ecs-vm-key"
  vpc_security_group_ids = ["sg-02eebdc31e2f8ad66"]

  tags = {
    Name = "Terraform-IaC"
  }
}
```

Before applying this configuration, make sure that:

- The AMI is available in `us-east-1`.
- The key pair exists in `us-east-1`.
- The security group exists in the same VPC where the instance will be launched.
- Your AWS credentials are configured and permitted to create EC2 instances.

## Run the configuration

Run the following commands from the `exercise1` directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review the plan and type `yes` when Terraform asks for confirmation.

## Check the instance

After a successful apply, view the resource managed by Terraform:

```bash
terraform state list
```

Expected resource:

```text
aws_instance.vm1
```

## Destroy resources

Destroy the EC2 instance when it is no longer needed to avoid AWS charges:

```bash
terraform destroy
```
