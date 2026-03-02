resource "aws_ec2_transit_gateway" "this" {
  description                     = "Enterprise multi-account transit gateway"
  amazon_side_asn                 = 64512
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "enable"

  tags = merge(var.tags, {
    Name = "enterprise-tgw"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = aws_vpc.this

  subnet_ids = [
    for az in local.azs : aws_subnet.private["${each.key}-${az}"].id
  ]

  vpc_id             = each.value.id
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = merge(var.tags, {
    Name    = "${each.key}-tgw-attachment"
    Account = each.key
  })
}
