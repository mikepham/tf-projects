locals {
  default_vpc = "vpc-044a446333ccec851"
}

resource "aws_route53_record" "nativecode_net" {
  name    = module.env.domain_root
  type    = "A"
  zone_id = data.aws_route53_zone.root.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.website.dns_name
    zone_id                = module.website.zone_id
  }
}

resource "aws_route53_record" "star_nativecode_net" {
  name    = "*.${module.env.domain_root}"
  type    = "A"
  zone_id = data.aws_route53_zone.root.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.website.dns_name
    zone_id                = module.website.zone_id
  }
}

resource "aws_route53_record" "gitlab" {
  name    = "git.${module.env.domain_root}"
  type    = "A"
  zone_id = data.aws_route53_zone.root.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.website.dns_name
    zone_id                = module.website.zone_id
  }
}

resource "aws_lb_target_group" "gitlab" {
  name     = "gitlab"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.default_vpc

  health_check {
    path = "/-/liveness"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "gitlab" {
  target_group_arn = aws_lb_target_group.gitlab.arn
  target_id        = data.aws_instance.gitlab.id
  port             = 80
}

resource "aws_lb_target_group" "wordpress" {
  name     = "wordpress"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.default_vpc

  health_check {
    matcher = "200,302"
    path    = "/index.php"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "wordpress" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = data.aws_instance.wordpress.id
  port             = 80
}

module "root_certificate" {
  source           = "./modules/aws/certificate"
  domain           = module.env.domain_root
  cert_domain      = "*.${module.env.domain_root}"
  cert_domain_alts = [module.env.domain_root]
  project_name     = local.project_name
  zone_id          = module.domain.zone_id
}

module "website" {
  source           = "./modules/aws/lb"
  certificate_arn  = module.root_certificate.certificate_id
  domain           = module.env.domain_root
  project_name     = local.project_name
  subnets          = ["subnet-061f64ab05defa527", "subnet-0a39e64f6b4f2d11f", "subnet-09972a4049f4674fc"]
  target_group_arn = aws_lb_target_group.wordpress.arn
  vpc_id           = local.default_vpc

  rules = [
    {
      host_header      = ["git.${module.env.domain_root}"]
      target_group_arn = aws_lb_target_group.gitlab.arn
    },
  ]
}
