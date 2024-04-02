data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  vpc_cidr = "10.0.0.0/16" # VPCのCIDRブロック
}

# --------------------------------
# VPC
# --------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = local.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------------
# Subnet
# --------------------------------
resource "aws_subnet" "public_subnet" {
  for_each = { for az in data.aws_availability_zones.available.names : az => az }

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(local.vpc_cidr, 8, index(data.aws_availability_zones.available.names, each.key))
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-${each.key}"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = { for az in data.aws_availability_zones.available.names : az => az }

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(local.vpc_cidr, 8, index(data.aws_availability_zones.available.names, each.key) + length(aws_subnet.public_subnet))
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-${each.key}"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }

}
# --------------------------------
# Route Table
# --------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    type    = "public"
  }
}

resource "aws_route_table_association" "public_rt" {
  for_each       = aws_subnet.public_subnet
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = each.value.id
}

resource "aws_route_table" "private_rt" {
  for_each = aws_subnet.public_subnet
  vpc_id   = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    Project = var.project
    Env     = var.environment
    type    = "private"
  }
}

resource "aws_route_table_association" "private_rt" {
  for_each       = aws_subnet.private_subnet
  route_table_id = aws_route_table.private_rt[each.key].id
  subnet_id      = each.value.id
}

# --------------------------------
# Internet Gateway
# --------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# --------------------------------
# NAT Gateway
# --------------------------------


resource "aws_eip" "main" {
  for_each   = aws_subnet.public_subnet
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name    = "${var.project}-${var.environment}-eip-${each.key}"
    Project = var.project
    Env     = var.environment
  }

}

resource "aws_nat_gateway" "main" {
  for_each      = aws_subnet.public_subnet
  allocation_id = aws_eip.main[each.key].id
  subnet_id     = each.value.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name    = "${var.project}-${var.environment}-nat-gateway-${each.key}"
    Project = var.project
    Env     = var.environment
  }
}

