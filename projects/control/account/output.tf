output "user_account_id" {
  description = "Current User Account ID"
  value       = local.user_account_id
}

output "user_arn" {
  description = "Current User ARN"
  value       = local.user_arn
}

output "user_id" {
  description = "Current User ID"
  value       = local.user_id
}

output "zones" {
  description = "AWS Zones"
  value       = data.aws_route53_zone.zones
}
