resource "aws_route53_record" "domain" {
  name    = module.env.domain_name
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

resource "aws_route53_record" "domain-wildcard" {
  name    = "*.${module.env.domain_name}"
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

/*
resource "aws_route53_record" "jackett" {
  name    = "jackett.${module.env.domain_root}"
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

resource "aws_route53_record" "nzbhydra" {
  name    = "nzbhydra.${module.env.domain_root}"
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

resource "aws_route53_record" "phamflix" {
  name    = "phamflix.${module.env.domain_root}"
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}
*/
