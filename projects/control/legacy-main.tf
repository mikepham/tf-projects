module "domain" {
  source = "../../modules/aws/domain"
  domain = local.domain
}

module "env" {
  source = "../../modules/common/env"
  domain = local.domain
}

module "certificate" {
  source           = "../../modules/aws/certificate"
  domain           = module.env.domain_root
  cert_domain      = "*.${module.env.domain_root}"
  cert_domain_alts = [module.env.domain_root]
  project_name     = local.project_name
  zone_id          = module.domain.zone_id
}
