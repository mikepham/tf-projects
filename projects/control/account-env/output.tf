output "subdomains" {
  description = "List of subdomain zones"
  value       = aws_route53_zone.zones
}

output "user_account_id" {
  description = "Current User Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "user_arn" {
  description = "Current User ARN"
  value       = data.aws_caller_identity.current.arn
}

output "user_id" {
  description = "Current User ID"
  value       = data.aws_caller_identity.current.user_id
}
