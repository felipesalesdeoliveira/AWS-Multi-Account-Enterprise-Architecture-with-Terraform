variable "region" {
  description = "AWS region for centralized security services"
  type        = string
  default     = "us-east-1"
}

variable "cloudtrail_bucket_name" {
  description = "S3 bucket for organization CloudTrail logs"
  type        = string
}

variable "config_bucket_name" {
  description = "S3 bucket for AWS Config snapshots"
  type        = string
}

variable "trail_name" {
  description = "CloudTrail name"
  type        = string
  default     = "org-cloudtrail"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project = "aws-multi-account-enterprise"
    Layer   = "security"
  }
}
