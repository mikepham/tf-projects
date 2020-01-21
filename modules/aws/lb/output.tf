output "arn" {
  value = aws_lb.lb.arn
}

output "arn_suffix" {
  value = aws_lb.lb.arn_suffix
}

output "dns_name" {
  value = aws_lb.lb.dns_name
}

output "id" {
  value = aws_lb.lb.id
}

output "name" {
  value = var.domain
}

output "security_group" {
  value = aws_security_group.default.id
}

output "zone_id" {
  value = aws_lb.lb.zone_id
}
