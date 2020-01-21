resource "random_id" "secret" {
  byte_length = 5
}

resource "aws_secretsmanager_secret" "secret_key" {
  name = "${var.secret_name}-${random_id.secret.hex}"

  tags = {
    Name       = var.domain
    Project    = var.project_name
    SecretName = var.secret_name
  }
}

resource "aws_secretsmanager_secret_version" "secrets_json" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = jsonencode(var.secrets)
}
