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
  profile = "nativecode"
  region  = "us-east-1"
}

module "account" {
  source     = "./account"
  domains    = local.domains
  envdomains = local.envdomains
}

module "legacy" {
  source       = "./legacy"
  domain       = local.domain
  project_name = "legacy"
}

module "prod" {
  source = "./account-env"

  account_id  = local.root_account
  domains     = local.domains
  environment = "prod"
  users       = local.users
}
