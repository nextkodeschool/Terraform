# Replace this placeholder with the instance ID of the manually created web03-dev EC2 instance.
import {
  to = module.web03.aws_instance.ec2
  id = "i-REPLACE_WITH_WEB03_DEV_INSTANCE_ID"
}

# The S3 bucket import ID is the bucket name.
import {
  to = module.s3_2.aws_s3_bucket.s3
  id = "terraformnks2026-dev"
}