output "certificate_arn" {
  description = "Certificate ARN"
  value       = aws_acm_certificate.certificate.arn
}

output "certificate_id" {
  description = "Certificate ID"
  value       = aws_acm_certificate.certificate.id
}

output "domain_name" {
  description = "Domain Name"
  value       = aws_acm_certificate.certificate.domain_name
}

output "fqdn" {
  description = "FQDN"
  value       = aws_route53_record.dns.fqdn
}
