output "efs_arn" {
  description = "OBSOLETE"
  value       = aws_efs_file_system.efs.arn
}

output "efs_dns_name" {
  description = "OBSOLETE"
  value       = aws_efs_file_system.efs.dns_name
}

output "efs_id" {
  description = "OBSOLETE"
  value       = aws_efs_file_system.efs.id
}

output "efs_security_group" {
  description = "OBSOLETE"
  value       = aws_security_group.efs.id
}

output "arn" {
  description = "EFS ARN"
  value       = aws_efs_file_system.efs.arn
}

output "dns_name" {
  description = "EFS DNS Name"
  value       = aws_efs_file_system.efs.dns_name
}

output "id" {
  description = "EFS ID"
  value       = aws_efs_file_system.efs.id
}

output "security_groups" {
  value = [aws_security_group.efs.id]
}

