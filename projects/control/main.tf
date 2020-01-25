terraform {
  backend "s3" {
    bucket  = "nativecode"
    encrypt = true
    key     = "nativecode-control.tfstate"
    profile = "nativecode"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

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
