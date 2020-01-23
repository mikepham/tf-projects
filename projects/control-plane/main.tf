terraform {
  backend "s3" {
    bucket  = "nativecode"
    encrypt = true
    key     = "nativecode-control-plane.tfstate"
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
