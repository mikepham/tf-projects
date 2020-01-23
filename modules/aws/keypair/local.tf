locals {
  keypair_names    = aws_key_pair.keypair.key_name
  pem_filename     = "${local.pem_keypair_name}.pem"
  pem_keypair_name = var.domain
}
