resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "sso.amazonaws.com"
  ]

  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.this.roots[0].id
}

locals {
  accounts = {
    security = {
      name      = "Security Account"
      email     = var.account_emails.security
      parent_id = aws_organizations_organizational_unit.security.id
    }
    shared = {
      name      = "Shared Services Account"
      email     = var.account_emails.shared
      parent_id = aws_organizations_organizational_unit.workloads.id
    }
    prod = {
      name      = "Production Account"
      email     = var.account_emails.prod
      parent_id = aws_organizations_organizational_unit.workloads.id
    }
    staging = {
      name      = "Staging Account"
      email     = var.account_emails.staging
      parent_id = aws_organizations_organizational_unit.workloads.id
    }
    dev = {
      name      = "Development Account"
      email     = var.account_emails.dev
      parent_id = aws_organizations_organizational_unit.workloads.id
    }
  }
}

resource "aws_organizations_account" "accounts" {
  for_each = local.accounts

  name      = each.value.name
  email     = each.value.email
  parent_id = each.value.parent_id

  role_name                  = var.account_role_name
  close_on_deletion          = false
  iam_user_access_to_billing = "ALLOW"

  tags = merge(var.tags, {
    Name        = each.value.name
    Environment = each.key
  })
}
