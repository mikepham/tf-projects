output "key_name" {
  value = local.pem_keypair_name
}

output "key_path" {
  value = local_file.pem.filename
}

output "private_key_pem" {
  value = module.tls.private_key_pem
}

output "public_key_pem" {
  value = module.tls.public_key_pem
}

output "kms_key_arn" {
  value = aws_kms_key.kms.arn
}

output "kms_key_id" {
  value = aws_kms_key.kms.key_id
}
