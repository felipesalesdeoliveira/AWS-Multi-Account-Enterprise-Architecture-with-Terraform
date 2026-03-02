variable "region" {
  description = "AWS region for shared networking resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidrs" {
  description = "CIDR blocks per account/environment"
  type        = map(string)
  default = {
    security = "10.10.0.0/16"
    shared   = "10.20.0.0/16"
    prod     = "10.30.0.0/16"
    staging  = "10.40.0.0/16"
    dev      = "10.50.0.0/16"
  }
}

variable "az_count" {
  description = "Number of AZs used per VPC"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project = "aws-multi-account-enterprise"
    Layer   = "networking"
  }
}
