output "artifacts_bucket_name" {
  description = "Artifacts bucket name for the environment"
  value       = aws_s3_bucket.artifacts.id
}

output "log_group_name" {
  description = "CloudWatch log group for application logs"
  value       = aws_cloudwatch_log_group.application.name
}
