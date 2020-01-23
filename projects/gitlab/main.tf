terraform {
  backend "s3" {
    bucket  = "nativecode"
    encrypt = true
    key     = "nativecode-services-gitlab.tfstate"
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

module "keypair" {
  source       = "../../modules/aws/keypair"
  bucket_name  = "nativecode"
  domain       = local.domain
  project_name = local.project_name
}

module "user" {
  source       = "../../modules/aws/user"
  domain       = module.env.domain_name
  group_name   = local.project_name
  project_name = local.project_name
  user_name    = local.project_name
}

module "vpc" {
  source = "../../modules/aws/vpc"
  vpc_id = local.vpc_id
}
