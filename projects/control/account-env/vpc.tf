module "vpc" {
  source                         = "../../../modules/aws/vpc"
  environment                    = var.environment
  availability_zones             = ["us-east-1a", "us-east-1b"]
  project_name                   = "infrastructure"
  vpc_cidr_private_block_subnets = ["172.32.16.0/20", "172.32.32.0/20"]
  vpc_cidr_public_block_subnets  = ["172.32.128.0/20", "172.32.144.0/20"]
  vpc_cidr_block                 = "172.32.0.0/16"
}
