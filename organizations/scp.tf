resource "aws_organizations_policy" "restrict_regions_nonprod" {
  name        = "RestrictRegionsNonProd"
  description = "Blocks operations outside approved regions"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyUnsupportedRegions"
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = var.allowed_regions
          }
          ArnNotLike = {
            "aws:PrincipalARN" = [
              "arn:aws:iam::*:role/AWSControlTowerExecution",
              "arn:aws:iam::*:role/OrganizationAccountAccessRole"
            ]
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_organizations_policy" "enforce_prod_tag" {
  name        = "EnforceMandatoryTagInProd"
  description = "Deny EC2 instance creation in prod without required tag"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyRunInstancesWithoutMandatoryTag"
        Effect   = "Deny"
        Action   = "ec2:RunInstances"
        Resource = "*"
        Condition = {
          Null = {
            "aws:RequestTag/${var.required_tag_key}" = "true"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_organizations_policy" "deny_leave_org" {
  name        = "DenyLeaveOrganization"
  description = "Prevents child accounts from leaving the organization"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyLeaveOrganization"
        Effect   = "Deny"
        Action   = "organizations:LeaveOrganization"
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_organizations_policy_attachment" "restrict_regions_dev" {
  policy_id = aws_organizations_policy.restrict_regions_nonprod.id
  target_id = aws_organizations_account.accounts["dev"].id
}

resource "aws_organizations_policy_attachment" "restrict_regions_staging" {
  policy_id = aws_organizations_policy.restrict_regions_nonprod.id
  target_id = aws_organizations_account.accounts["staging"].id
}

resource "aws_organizations_policy_attachment" "enforce_tag_prod" {
  policy_id = aws_organizations_policy.enforce_prod_tag.id
  target_id = aws_organizations_account.accounts["prod"].id
}

resource "aws_organizations_policy_attachment" "deny_leave_root" {
  policy_id = aws_organizations_policy.deny_leave_org.id
  target_id = aws_organizations_organization.this.roots[0].id
}
