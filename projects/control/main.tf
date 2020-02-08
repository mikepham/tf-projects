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

module "dev" {
  source = "./account-env"

  account_id  = local.root_account
  domains     = local.domains
  environment = "dev"
  users       = local.users
}

module "test" {
  source = "./account-env"

  account_id  = local.root_account
  domains     = local.domains
  environment = "test"
  users       = local.users
}

module "stage" {
  source = "./account-env"

  account_id  = local.root_account
  domains     = local.domains
  environment = "stage"
  users       = local.users
}

module "prod" {
  source = "./account-env"

  account_id  = local.root_account
  domains     = local.domains
  environment = "prod"
  users       = local.users
}
