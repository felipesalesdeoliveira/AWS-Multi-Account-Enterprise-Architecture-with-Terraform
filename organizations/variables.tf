variable "region" {
  description = "AWS region used by Organizations API"
  type        = string
  default     = "us-east-1"
}

variable "account_emails" {
  description = "Email addresses for each AWS account"
  type = object({
    security = string
    shared   = string
    prod     = string
    staging  = string
    dev      = string
  })
}

variable "allowed_regions" {
  description = "Regions allowed by SCP for non-production accounts"
  type        = list(string)
  default     = ["us-east-1"]
}

variable "required_tag_key" {
  description = "Mandatory tag key required in production for EC2 runs"
  type        = string
  default     = "Owner"
}

variable "account_role_name" {
  description = "IAM role automatically created in new accounts"
  type        = string
  default     = "OrganizationAccountAccessRole"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project = "aws-multi-account-enterprise"
    Layer   = "organizations"
  }
}
