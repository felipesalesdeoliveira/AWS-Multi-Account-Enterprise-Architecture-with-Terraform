data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs          = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  account_keys = keys(var.vpc_cidrs)

  public_subnet_matrix = {
    for subnet in flatten([
      for account, cidr in var.vpc_cidrs : [
        for az_index, az in local.azs : {
          key        = "${account}-${az}"
          account    = account
          cidr_block = cidrsubnet(cidr, 4, az_index)
          az         = az
        }
      ]
    ]) : subnet.key => subnet
  }

  private_subnet_matrix = {
    for subnet in flatten([
      for account, cidr in var.vpc_cidrs : [
        for az_index, az in local.azs : {
          key        = "${account}-${az}"
          account    = account
          cidr_block = cidrsubnet(cidr, 4, az_index + 8)
          az         = az
        }
      ]
    ]) : subnet.key => subnet
  }
}

resource "aws_vpc" "this" {
  for_each = var.vpc_cidrs

  cidr_block           = each.value
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name    = "${each.key}-vpc"
    Account = each.key
  })
}

resource "aws_internet_gateway" "this" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  tags = merge(var.tags, {
    Name    = "${each.key}-igw"
    Account = each.key
  })
}

resource "aws_subnet" "public" {
  for_each = local.public_subnet_matrix

  vpc_id                  = aws_vpc.this[each.value.account].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name    = "${each.value.account}-public-${replace(each.value.az, var.region, "")}"
    Account = each.value.account
    Tier    = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = local.private_subnet_matrix

  vpc_id            = aws_vpc.this[each.value.account].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name    = "${each.value.account}-private-${replace(each.value.az, var.region, "")}"
    Account = each.value.account
    Tier    = "private"
  })
}

resource "aws_route_table" "public" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[each.key].id
  }

  tags = merge(var.tags, {
    Name    = "${each.key}-public-rt"
    Account = each.key
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.value.tags["Account"]].id
}

resource "aws_eip" "nat" {
  for_each = aws_vpc.this

  domain = "vpc"

  tags = merge(var.tags, {
    Name    = "${each.key}-nat-eip"
    Account = each.key
  })
}

resource "aws_nat_gateway" "this" {
  for_each = aws_vpc.this

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public["${each.key}-${local.azs[0]}"].id

  tags = merge(var.tags, {
    Name    = "${each.key}-nat"
    Account = each.key
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = merge(var.tags, {
    Name    = "${each.key}-private-rt"
    Account = each.key
  })
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.value.tags["Account"]].id
}
