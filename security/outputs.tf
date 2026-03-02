output "cloudtrail_bucket" {
  description = "Bucket storing organization CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail.id
}

output "config_bucket" {
  description = "Bucket storing AWS Config snapshots"
  value       = aws_s3_bucket.config.id
}

output "cloudtrail_arn" {
  description = "Organization CloudTrail ARN"
  value       = aws_cloudtrail.organization.arn
}
