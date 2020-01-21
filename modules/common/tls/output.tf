output "private_key_pem" {
  value = tls_private_key.tls.private_key_pem
}

output "public_key_pem" {
  value = tls_private_key.tls.public_key_pem
}

output "fingerprint" {
  value = tls_private_key.tls.public_key_fingerprint_md5
}

output "public_key_openssh" {
  value = tls_private_key.tls.public_key_openssh
}
