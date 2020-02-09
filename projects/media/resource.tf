resource "random_string" "database_password" {
  length      = 24
  lower       = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 0
  number      = true
  upper       = true
  special     = false
}

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
