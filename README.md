# Terraform July Batch

This repository contains hands-on Terraform exercises for learning how to provision AWS infrastructure with Infrastructure as Code (IaC).

The exercises build progressively from a single EC2 instance to reusable modules, multiple environments, and remote state.

## Exercises

| Exercise | Topics | Resources |
| --- | --- | --- |
| [Exercise 1](exercise1/README.md) | Terraform basics, AWS provider, and a single resource | One EC2 instance |
| [Exercise 2](exercise2/README.md) | Input variables, variable files, outputs | One EC2 instance and one S3 bucket |
| [Exercise 3](exercise3/README.md) | Reusable modules and S3 remote state | Two EC2 instances and one S3 bucket |
| [Exercise 4](exercise4/README.md) | Environment-specific variable files and resource naming | Two EC2 instances and one S3 bucket per environment |

## Learning path

```text
Exercise 1: Create one EC2 instance
        ↓
Exercise 2: Use variables and create EC2 + S3
        ↓
Exercise 3: Reuse EC2 and S3 modules
        ↓
Exercise 4: Deploy the modules for dev, qa, and prod
```

## Prerequisites

Before running an exercise, install and configure:

- [Terraform](https://developer.hashicorp.com/terraform/install) version 1.5 or later
- AWS CLI with valid AWS credentials
- An EC2 key pair, security group, and AMI available in the AWS region you plan to use

Verify your AWS credentials:

```bash
aws sts get-caller-identity
```

## AWS authentication and IAM permissions

Terraform needs AWS credentials to authenticate with your cloud account. Prefer an **IAM role** when running from AWS services or CI/CD. For local learning, you can use IAM access keys for a dedicated IAM user:

```bash
aws configure
```

Do not use the AWS root user. Create a dedicated IAM user or role for Terraform and attach only the policies it needs for the resources in the exercise, such as EC2, S3, and the remote-state bucket.

Follow the principle of least privilege:

- Start with the minimum permissions required to create, read, update, and delete the Terraform-managed resources.
- Restrict permissions to the required AWS region, resources, and S3 buckets where possible.
- Store access keys securely; never commit them to this repository or a `.tfvars` file.
- Rotate or remove unused access keys and roles.

Avoid attaching the `AdministratorAccess` policy to a Terraform IAM user or role. If it is temporarily needed to test a lab configuration, use it only in a separate testing account and replace it with a least-privilege policy before deploying to a live environment.

## Run an exercise

Change into the exercise directory and use the normal Terraform workflow:

```bash
cd exercise1
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Exercises 3 and 4 use an S3 backend for Terraform state. Create the configured backend bucket before running `terraform init` for either exercise.

## Clean up

Destroy resources after completing an exercise to avoid AWS charges:

```bash
terraform destroy
```

For Exercise 4, use the same environment variable file used for deployment:

```bash
terraform destroy -var-file="dev.tfvars"
```

---

## ✨ Learn With Us

> ### 🚀 Start your cloud journey with NextKodeSchool
>
> Join our live online sessions to learn Terraform and cloud technologies. Contact us to know when the next batch begins.

| 🌐 Visit us | 📞 Call us |
| --- | --- |
| [**nextkodeschool.com**](https://www.nextkodeschool.com) | [**+91 9493322788**](tel:+919493322788) · [**+91 7036227775**](tel:+917036227775) |
