resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private[0].id

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.availability_zones)
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = element(var.vpc_cidr_private_block_subnets, count.index)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name    = "private-${element(var.availability_zones, count.index)}-${var.domain}"
    Project = var.project_name
    Subnet  = "private"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = element(var.vpc_cidr_public_block_subnets, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name    = "public-${element(var.availability_zones, count.index)}-${var.domain}"
    Project = var.project_name
    Subnet  = "public"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group-${var.domain}"
  subnet_ids = concat(aws_subnet.private[*].id, aws_subnet.public[*].id)

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name    = "private-${var.domain}"
    Project = var.project_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name    = "public-${var.domain}"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_default_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "default-${var.domain}"
    Project = var.project_name
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name    = "default-${var.domain}"
    Project = var.project_name
  }
}
