output "cidr_block" {
  value = data.aws_vpc.vpc.cidr_block
}

output "id" {
  description = "OBSOLETE"
  value       = data.aws_vpc.vpc.id
}

output "subnets" {
  value = data.aws_subnet_ids.subnets.ids
}

output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

