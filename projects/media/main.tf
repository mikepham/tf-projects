terraform {
  backend "s3" {
    bucket  = "nativecode"
    encrypt = true
    key     = "nativecode-services-media.tfstate"
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
  domain           = module.env.domain_name
  cert_domain      = "*.${module.env.domain_name}"
  cert_domain_alts = [module.env.domain_name]
  project_name     = local.project_name
  zone_id          = module.domain.zone_id
}

module "secrets" {
  source       = "../../modules/aws/secret"
  domain       = module.env.domain_name
  project_name = local.project_name
  secret_name  = module.env.domain_slug
  secrets      = local.secrets
}

module "user" {
  source       = "../../modules/aws/user"
  domain       = module.env.domain_name
  group_name   = local.project_name
  project_name = local.project_name
  user_name    = local.project_name
}

module "loadbalancer" {
  source                      = "../../modules/aws/lb"
  additional_certificate_arns = local.additional_certificate_arns
  certificate_arn             = module.certificate.certificate_id
  domain                      = module.env.domain_name
  project_name                = local.project_name
  security_groups             = module.media_services.security_groups
  subnets                     = module.vpc.public
  target_group_arn            = module.media_services.target_group_arns[2]
  vpc_id                      = module.vpc.vpc_id

  rules = module.media_services.rules
}

module "vpc" {
  source      = "../../modules/aws/vpc-network"
  environment = terraform.workspace
}

module "cluster" {
  source                    = "../../modules/aws/ecs-cluster"
  cluster_name              = module.env.domain_slug
  enable_container_insights = false
  project_name              = local.project_name
}

module "media_services" {
  source             = "../../modules/aws/ecs-service"
  allowed_hosts      = local.allowed_hosts
  availability_zones = local.availability_zones
  cluster_id         = module.cluster.cluster_id
  domain             = module.env.domain_name
  project_name       = local.project_name
  secret_resources   = [module.secrets.arn]
  subnets            = module.vpc.public
  vpc_id             = module.vpc.vpc_id

  containers = [
    {
      cidr_blocks              = ["0.0.0.0/0"]
      cpu                      = 512
      definitions              = data.template_file.jackett.rendered
      desired_count            = 1
      dns_name                 = "jackett.${module.env.domain_name}"
      family                   = "jackett"
      health_check_path        = "/UI/Login"
      launch_type              = "FARGATE"
      log_name                 = "jackett"
      memory                   = 1024
      name                     = "jackett"
      network_mode             = "awsvpc"
      port                     = 9117
      public_ip                = true
      requires_compatibilities = ["FARGATE"]
      security_groups          = []
      volumes                  = []
    },
    {
      cidr_blocks              = ["0.0.0.0/0"]
      cpu                      = 512
      definitions              = data.template_file.nzbhydra.rendered
      desired_count            = 1
      dns_name                 = "nzbhydra.${module.env.domain_name}"
      family                   = "nzbhydra"
      health_check_path        = "/login"
      launch_type              = "FARGATE"
      log_name                 = "nzbhydra"
      memory                   = 1024
      name                     = "nzbhydra"
      network_mode             = "awsvpc"
      port                     = 5076
      public_ip                = true
      requires_compatibilities = ["FARGATE"]
      security_groups          = []
      volumes                  = []
    },
    {
      cidr_blocks              = ["0.0.0.0/0"]
      cpu                      = 512
      definitions              = data.template_file.phamflix.rendered
      desired_count            = 1
      dns_name                 = "phamflix.${module.env.domain_name}"
      family                   = "phamflix"
      health_check_path        = "/login"
      launch_type              = "FARGATE"
      log_name                 = "phamflix"
      memory                   = 1024
      name                     = "phamflix"
      network_mode             = "awsvpc"
      port                     = 3579
      public_ip                = true
      requires_compatibilities = ["FARGATE"]
      security_groups          = []
      volumes                  = []
  }]

  policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}
