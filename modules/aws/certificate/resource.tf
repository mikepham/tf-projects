resource "aws_route53_record" "dns" {
  allow_overwrite = true
  name            = aws_acm_certificate.certificate.domain_validation_options[0].resource_record_name
  records         = [aws_acm_certificate.certificate.domain_validation_options[0].resource_record_value]
  type            = aws_acm_certificate.certificate.domain_validation_options[0].resource_record_type

  ttl     = 60
  zone_id = var.zone_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.cert_domain
  subject_alternative_names = var.cert_domain_alts
  validation_method         = var.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "validaton" {
  depends_on              = [aws_route53_record.dns]
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [aws_route53_record.dns.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}
