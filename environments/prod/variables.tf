variable "region" {
  description = "AWS region for the prod environment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project slug used in resource naming"
  type        = string
  default     = "aws-multi-account-enterprise"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project     = "aws-multi-account-enterprise"
    Environment = "prod"
    Layer       = "environment"
  }
}
