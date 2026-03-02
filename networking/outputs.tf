output "vpc_ids" {
  description = "VPC IDs keyed by account/environment"
  value = {
    for k, v in aws_vpc.this :
    k => v.id
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs grouped by account/environment"
  value = {
    for account in local.account_keys :
    account => [for az in local.azs : aws_subnet.private["${account}-${az}"].id]
  }
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.this.id
}
