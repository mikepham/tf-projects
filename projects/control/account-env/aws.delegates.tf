#------------------------------------------------------------------------------
# Create Route53 Hosted Zones
#------------------------------------------------------------------------------
resource "aws_route53_zone" "zones" {
  count   = length(var.domains)
  comment = "Subdomain of ${var.domains[count.index]}"
  name    = "${var.environment}.${element(var.domains, count.index)}"
}

#------------------------------------------------------------------------------
# Create Route53 Hosted Sub Zones
#------------------------------------------------------------------------------
resource "aws_route53_zone" "subzones" {
  count = length(var.subdomains)
  name  = replace(element(var.subdomains, count.index), "*", var.environment)
}
