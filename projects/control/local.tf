locals {
  default_vpc                    = "vpc-044a446333ccec851"
  domain                         = "nativecode.net"
  full_aws_access                = "arn:aws:organizations::aws:policy/service_control_policy/p-FullAWSAccess"
  project_name                   = "control-plane"
  root_account                   = "329267330377"
  vpc_nat_private_ip             = "172.100.0.10"
  vpc_cidr_block                 = "172.100.0.0/16"
  vpc_cidr_private_block_subnets = ["172.100.0.0/22", "172.100.4.0/22", "172.100.8.0/22"]
  vpc_cidr_public_block_subnets  = ["172.100.128.0/22", "172.100.132.0/22", "172.100.136.0/22"]

  environments = [
    {
      arn = aws_organizations_account.dev.arn
      id  = aws_organizations_account.dev.id
    },
    {
      arn = aws_organizations_account.test.arn
      id  = aws_organizations_account.test.id
    },
    {
      arn = aws_organizations_account.stage.arn
      id  = aws_organizations_account.stage.id
    },
    {
      arn = aws_organizations_account.prod.arn
      id  = aws_organizations_account.prod.id
    },
  ]
}
