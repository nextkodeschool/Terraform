# Exercise 6: Import Existing AWS Resources

Exercise 6 manages the development resources that already exist in AWS, plus the same modular multi-environment structure used in Exercise 4.

The development configuration includes:

- `web01-dev` and `web02-dev` EC2 instances
- `web03-dev` EC2 instance, created manually in the AWS console
- Original S3 bucket: `devopsbatchjuly2026nks-dev`
- `terraformnks2026-dev` S3 bucket, created manually in the AWS console and imported

`web03-dev` is configured with the same AMI, instance type, key pair, and security group inputs as `web01-dev` and `web02-dev`. Both S3 modules append the environment to their base-name variables: `bucket_name` creates the original bucket and `bucket2_name` creates the second bucket.

## What `terraform import` does

`terraform import` adds an existing remote object to the current Terraform state at a resource address. It does **not** create the object, generate Terraform configuration, or change the object during the import itself.

Import workflow:

```text
Existing AWS resource + matching .tf resource block
                    │
                    ▼
            terraform import
                    │
                    ▼
          Terraform state tracks it
                    │
                    ▼
       terraform plan reviews differences
```

The Terraform configuration must exist before import. Always run `terraform plan` afterwards and update the configuration if Terraform proposes changes you do not want.

## Directory structure

```text
exercise6/
├── backend.tf
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── imports.tf
├── dev.tfvars
├── qa.tfvars
├── prod.tfvars
└── modules/
    ├── ec2/
    └── s3/
```

## Ad hoc import commands

`imports.tf` already contains declarative import blocks for `web03-dev` and `terraformnks2026-dev`. Replace `i-REPLACE_WITH_WEB03_DEV_INSTANCE_ID` in that file with the real EC2 instance ID, then run a plan and apply:

```bash
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

Do not run the ad hoc commands below after using `imports.tf`; each AWS resource must be imported only once into a state.

Run these commands from the `exercise6` directory. Replace `i-xxxxxxxxxxxxxxxxx` with the actual instance ID of the manually created `web03-dev` instance.

```bash
terraform init
terraform fmt -recursive
terraform validate

terraform import -var-file="dev.tfvars" 'module.web03.aws_instance.ec2' i-xxxxxxxxxxxxxxxxx
terraform import -var-file="dev.tfvars" 'module.s3_2.aws_s3_bucket.s3' terraformnks2026-dev

terraform plan -var-file="dev.tfvars"
```

You can obtain the EC2 ID in the AWS EC2 console, or with the AWS CLI:

```bash
aws ec2 describe-instances \
  --filters 'Name=tag:Name,Values=web03-dev' 'Name=instance-state-name,Values=running,pending,stopped,stopping' \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text \
  --region us-east-1
```

Useful import examples:

```bash
# EC2 resource inside a module
terraform import -var-file="dev.tfvars" 'module.web03.aws_instance.ec2' i-0123456789abcdef0

# Second S3 bucket inside a module (the import ID is the bucket name)
terraform import -var-file="dev.tfvars" 'module.s3_2.aws_s3_bucket.s3' terraformnks2026-dev
```

Use `terraform state list` to confirm the imported addresses, and `terraform state show '<address>'` to inspect an imported resource.

## Deploy or manage an environment

```bash
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

Use the equivalent `qa.tfvars` or `prod.tfvars` file for those environments. The backend state key is `exercise6/terraform.tfstate`, separate from Exercise 4's state key.

## Inputs

| Variable | Description |
| --- | --- |
| `aws_region` | AWS region used by the provider |
| `environment` | Environment tag such as `dev`, `qa`, or `prod` |
| `ami_id` | AMI ID for the EC2 instances |
| `instance_type` | EC2 instance size |
| `key_name` | Existing EC2 key pair name |
| `ec2_sg` | Security group ID assigned to each EC2 instance |
| `bucket_name` | Base name of the original S3 bucket |
| `bucket2_name` | Base name of the second S3 bucket to import |

## Important notes

- Import each remote object only once into a Terraform state. Do not import the same AWS resource at more than one address. In this exercise, the manually created `web03-dev` instance belongs only at `module.web03.aws_instance.ec2`, and the manually created `terraformnks2026-dev` bucket belongs only at `module.s3_2.aws_s3_bucket.s3`.

  For example, after importing the bucket at `module.s3_2.aws_s3_bucket.s3`, do **not** run an import that maps `terraformnks2026-dev` to `module.s3.aws_s3_bucket.s3` or any other address. Likewise, do not import the `web03-dev` instance at `module.web01.aws_instance.ec2` or `module.web02.aws_instance.ec2`. Two Terraform addresses tracking one AWS object can cause an unexpected plan, conflicting updates, or accidental deletion.
- If `terraform plan` shows a replacement or an unwanted change after import, stop and reconcile the `.tf` configuration with the real AWS resource before applying.
- `terraform destroy -var-file="dev.tfvars"` will delete resources managed in the active state, including imported resources. Use it carefully.
