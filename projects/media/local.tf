locals {
  allowed_hosts                  = ["97.106.33.210/32"]
  availability_zones             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  domain                         = "nativecode.net"
  project_name                   = "media"
  vpc_nat_private_ip             = "172.100.0.10"
  vpc_cidr_block                 = "172.100.0.0/16"
  vpc_cidr_private_block_subnets = ["172.100.0.0/22", "172.100.4.0/22", "172.100.8.0/22"]
  vpc_cidr_public_block_subnets  = ["172.100.128.0/22", "172.100.132.0/22", "172.100.136.0/22"]

  secrets = {
    "AWS_ACCESS_KEY_ID" : module.user.access_key
    "AWS_SECRET_ACCESS_KEY" : module.user.secret_key
  }

  additional_certificate_arns = [
    "arn:aws:acm:us-east-1:329267330377:certificate/15cb6eaa-4e61-44fb-b7b6-2bdb86b878d4"
  ]
}
