output "arn" {
  value = aws_secretsmanager_secret.secret_key.arn
}

output "secret" {
  description = "Environment Secrets"
  value       = jsondecode(aws_secretsmanager_secret_version.secrets_json.secret_string)
}
