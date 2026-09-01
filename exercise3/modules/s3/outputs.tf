output "bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.s3.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.s3.arn
}
