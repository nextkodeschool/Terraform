# Terraform Modules 

* 🖥️ **EC2 #1 → `web01`**
* 🖥️ **EC2 #2 → `web02`**
* 🪣 **S3 → one bucket**
* 🏷️ **Environment = `dev`** passed from the root to both modules
* Same variable names between root and modules to keep it easy for students.

The important new concept is that we will call the **same EC2 module twice**.

# 📁 Directory Structure

```text
terraform-project/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
│
└── modules/
    │
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── s3/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

# 1. `provider.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

# 2. Root `variables.tf`

We need the EC2 information, S3 information, and common environment.

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ec2_sg" {
  description = "EC2 security group ID"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}
```

Notice we **don't need separate variables** like:

```text
web01_ami_id
web02_ami_id
```

because both EC2s will use the same AMI, instance type, key, and security group.

Only their **names** will be different.

---

# 3. `terraform.tfvars`

```hcl
aws_region = "us-east-1"

environment = "dev"

ami_id = "ami-xxxxxxxxxxxxxxxxx"

instance_type = "t3.micro"

key_name = "chilling"

ec2_sg = "sg-xxxxxxxxxxxxxxxxx"

bucket_name = "devops-august-2026-demo"
```

Replace the sample AMI, security group, key name, and bucket name with your actual values.

---

# 4. Root `main.tf`

This is where the interesting change happens.

We call the **same EC2 module twice**.

```hcl
module "web01" {

  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  ec2_sg        = var.ec2_sg
  instance_name = "web01"
  environment   = var.environment
}


module "web02" {

  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  ec2_sg        = var.ec2_sg
  instance_name = "web02"
  environment   = var.environment
}


module "s3" {

  source = "./modules/s3"

  bucket_name = var.bucket_name
  environment = var.environment
}
```

### 🔥 This is the important concept

We have **one EC2 module**:

```text
modules/ec2/
```

But we use it twice:

```text
             EC2 MODULE
                 │
          ┌──────┴──────┐
          ▼             ▼
       web01          web02
```

We don't create:

```text
modules/web01/
modules/web02/
```

That would defeat the purpose of a reusable module.

---

# 5. EC2 Module — `modules/ec2/variables.tf`

```hcl
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ec2_sg" {
  description = "EC2 security group ID"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
```

---

# 6. EC2 Module — `modules/ec2/main.tf`

```hcl
resource "aws_instance" "ec2" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg]

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
```

The module doesn't know whether it's creating `web01` or `web02`.

It simply receives:

```text
instance_name
```

from the root.

For the first call:

```hcl
instance_name = "web01"
```

For the second:

```hcl
instance_name = "web02"
```

---

# 7. EC2 Module — `modules/ec2/outputs.tf`

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ec2.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.ec2.public_ip
}

output "private_ip" {
  description = "EC2 private IP"
  value       = aws_instance.ec2.private_ip
}
```

---

# 8. S3 Module — `modules/s3/variables.tf`

```hcl
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
```

---

# 9. S3 Module — `modules/s3/main.tf`

```hcl
resource "aws_s3_bucket" "s3" {

  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}
```

---

# 10. S3 Module — `modules/s3/outputs.tf`

```hcl
output "bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.s3.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.s3.arn
}
```

---

# 11. Root `outputs.tf`

Because we now have **two EC2 module instances**, we reference them separately.

```hcl
output "web01_instance_id" {
  description = "Web01 EC2 instance ID"
  value       = module.web01.instance_id
}

output "web01_public_ip" {
  description = "Web01 public IP"
  value       = module.web01.public_ip
}

output "web01_private_ip" {
  description = "Web01 private IP"
  value       = module.web01.private_ip
}


output "web02_instance_id" {
  description = "Web02 EC2 instance ID"
  value       = module.web02.instance_id
}

output "web02_public_ip" {
  description = "Web02 public IP"
  value       = module.web02.public_ip
}

output "web02_private_ip" {
  description = "Web02 private IP"
  value       = module.web02.private_ip
}


output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3.bucket_arn
}
```

---

# 🔄 What Terraform Sees

Your root `main.tf` essentially says:

```text
                ROOT
                 │
        ┌────────┼────────┐
        │        │        │
        ▼        ▼        ▼
      web01    web02      s3
        │        │        │
        ▼        ▼        ▼
    EC2 Module EC2 Module S3 Module
        │        │        │
        ▼        ▼        ▼
      EC2      EC2       S3
```

And both EC2 instances use:

```text
ami_id
instance_type
key_name
ec2_sg
environment
```

But their names differ:

```text
web01 → instance_name = "web01"

web02 → instance_name = "web02"
```

---

# 🎯 The Key Learning Point

This is the beauty of modules:

Without modules, you might write:

```hcl
resource "aws_instance" "web01" {
  ...
}

resource "aws_instance" "web02" {
  ...
}
```

That's duplicated EC2 configuration.

With a module:

```hcl
module "web01" {
  source = "./modules/ec2"
  ...
}

module "web02" {
  source = "./modules/ec2"
  ...
}
```

The **logic exists only once**:

```text
modules/ec2/main.tf
```

but you can create:

```text
web01
web02
web03
web04
...
```

by calling the same module multiple times.

### 🟢 Beginner takeaway

> **Module = reusable infrastructure blueprint.**

```text
One EC2 module
       │
       ├── web01
       ├── web02
       ├── web03
       └── web04
```

That's the concept I would emphasize to students before moving on to `count` and `for_each`.

