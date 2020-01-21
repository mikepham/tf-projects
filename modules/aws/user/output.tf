output "access_key" {
  value = aws_iam_access_key.user.id
}

output "arn" {
  value = aws_iam_user.user.arn
}

output "id" {
  value = aws_iam_user.user.id
}

output "secret_key" {
  value = aws_iam_access_key.user.secret
}
