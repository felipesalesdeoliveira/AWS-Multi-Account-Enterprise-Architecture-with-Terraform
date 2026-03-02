variable "region" {
  description = "AWS region for backend resources"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state lock"
  type        = string
  default     = "terraform-state-locks"
}

variable "tags" {
  description = "Common tags for backend resources"
  type        = map(string)
  default = {
    Project = "aws-multi-account-enterprise"
    Layer   = "backend"
  }
}
