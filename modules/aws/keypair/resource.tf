resource "aws_key_pair" "keypair" {
  depends_on = [module.tls]
  key_name   = var.domain
  public_key = module.tls.public_key_openssh

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "pem" {
  depends_on        = [module.tls]
  filename          = ".output/${local.pem_filename}"
  sensitive_content = join("", [module.tls.private_key_pem])
}

resource "aws_s3_bucket_object" "pemfile" {
  depends_on = [local_file.pem]
  bucket     = var.bucket_name
  key        = local.pem_filename
  source     = ".output/${local.pem_filename}"
}

resource "aws_kms_key" "kms" {
  description             = "KMS Key ${var.domain}"
  deletion_window_in_days = 10
}
