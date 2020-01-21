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
    Name    = var.project_name
    Project = var.project_name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private[0].id

  tags = {
    Name    = var.project_name
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = var.project_name
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

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

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

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_route_associations" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_route_associations" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}
