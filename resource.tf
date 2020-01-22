resource "aws_route53_record" "prod-nativecode-net" {
  name    = module.env.domain_name
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

resource "aws_route53_record" "star-prod-nativecode-net" {
  name    = "*.${module.env.domain_name}"
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

resource "aws_route53_record" "jackett" {
  name    = "jackett.${module.env.domain_root}"
  records = ["jackett.${module.env.domain_name}"]
  ttl     = "5"
  type    = "CNAME"
  zone_id = module.domain.zone_id
}

resource "aws_route53_record" "nzbhydra" {
  name    = "nzbhydra.${module.env.domain_root}"
  records = ["nzbhydra.${module.env.domain_name}"]
  ttl     = "5"
  type    = "CNAME"
  zone_id = module.domain.zone_id
}

resource "aws_route53_record" "phamflix" {
  name    = "phamflix.${module.env.domain_root}"
  records = ["phamflix.${module.env.domain_name}"]
  ttl     = "5"
  type    = "CNAME"
  zone_id = module.domain.zone_id
}
