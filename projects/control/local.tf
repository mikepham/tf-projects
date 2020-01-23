locals {
  default_vpc                    = "vpc-044a446333ccec851"
  domain                         = "nativecode.net"
  project_name                   = "control-plane"
  vpc_nat_private_ip             = "172.100.0.10"
  vpc_cidr_block                 = "172.100.0.0/16"
  vpc_cidr_private_block_subnets = ["172.100.0.0/22", "172.100.4.0/22", "172.100.8.0/22"]
  vpc_cidr_public_block_subnets  = ["172.100.128.0/22", "172.100.132.0/22", "172.100.136.0/22"]
}
