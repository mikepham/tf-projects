output "arn" {
  value = aws_vpc.vpc.arn
}

output "availability_zones" {
  value = var.availability_zones
}

output "default_network_acl_id" {
  value = aws_vpc.vpc.default_network_acl_id
}

output "default_route_table_id" {
  value = aws_vpc.vpc.default_route_table_id
}

output "default_security_group_id" {
  value = aws_vpc.vpc.default_security_group_id
}

output "db_subnet_group_arn" {
  value = aws_db_subnet_group.db_subnet_group.arn
}

output "id" {
  value = aws_vpc.vpc.id
}

output "main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}

output "private" {
  value = aws_subnet.private[*].id
}

output "public" {
  value = aws_subnet.public[*].id
}

output "public_route_table" {
  value = aws_route_table.public.id
}

output "subnets" {
  value = concat(aws_subnet.private[*].id, aws_subnet.public[*].id)
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
