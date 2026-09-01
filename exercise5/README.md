# Exercise 5: Website Deployment with User Data

This exercise is a copy of Exercise 4 with an additional EC2 user-data script. Each EC2 instance installs Apache and deploys the Chilling Cafe website during `terraform apply`.

It creates:

- Two EC2 instances: `web01` and `web02`
- One S3 bucket per selected environment
- Environment-specific resource names and tags
- An Apache website on both EC2 instances
- Remote Terraform state stored in S3

## Directory structure

```c#
exercise5/
├── backend.tf
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── dev.tfvars
├── qa.tfvars
├── prod.tfvars
└── modules/
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── website.sh
    └── s3/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Website deployment

The EC2 module loads the website script through the `user_data` block:

```hcl
user_data                   = file("${path.module}/website.sh")
user_data_replace_on_change = true
```

`website.sh` updates the Ubuntu server, installs Apache and required packages, downloads the Chilling Cafe template, and copies it to `/var/www/html/`.

Because the EC2 module is used twice, the website is deployed to both `web01` and `web02`.

## Before you deploy

- Use an Ubuntu AMI because `website.sh` uses `apt`.
- Allow inbound HTTP traffic on port `80` in the selected security group.
- Ensure the EC2 instances have internet access to download packages and website files.
- Update the `.tfvars` values for your AWS account before applying.

## Deploy an environment

Run the commands from the `exercise5` directory:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

After the instances start, open either output public IP address in a browser using `http://<public-ip>`. User data may take a few minutes to complete.

## Remote state

Exercise 5 uses the same S3 backend bucket as Exercise 4 but a separate state key:

```hcl
key = "exercise5/terraform.tfstate"
```

## Destroy resources

Use the same environment file that was used for deployment:

```bash
terraform destroy -var-file="dev.tfvars"
```
