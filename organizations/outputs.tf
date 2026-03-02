output "organization_id" {
  description = "AWS Organization ID"
  value       = aws_organizations_organization.this.id
}

output "root_id" {
  description = "Root OU ID"
  value       = aws_organizations_organization.this.roots[0].id
}

output "account_ids" {
  description = "Created account IDs keyed by logical environment"
  value = {
    for k, v in aws_organizations_account.accounts :
    k => v.id
  }
}
