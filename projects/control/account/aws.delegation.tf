#------------------------------------------------------------------------------
# Create Route53 Delegation NS Records
#------------------------------------------------------------------------------

resource "aws_route53_record" "subdomains" {
  count           = length(var.envdomains)
  allow_overwrite = true
  name            = element(var.envdomains.*.name, count.index)
  records         = element(var.envdomains.*.name_servers, count.index)
  ttl             = 30
  type            = "NS"
  zone_id         = element(data.aws_route53_zone.zones.*.zone_id, count.index)
}
