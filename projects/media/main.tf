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
  profile = "nativecode-${terraform.workspace}"
  region  = "us-east-1"
}

provider "mysql" {
  endpoint = local.secrets.DB_HOSTNAME
  username = local.secrets.DB_USERNAME
  password = local.secrets.DB_PASSWORD
}

module "domain" {
  source = "../../modules/aws/domain"
  domain = module.env.domain_name
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

module "keypair" {
  source       = "../../modules/aws/keypair"
  bucket_name  = module.private_bucket.id
  domain       = module.env.domain_name
  project_name = local.project_name
}

module "user" {
  source       = "../../modules/aws/user"
  domain       = module.env.domain_name
  group_name   = local.project_name
  project_name = local.project_name
  user_name    = local.project_name
}

module "private_bucket" {
  source        = "../../modules/aws/bucket"
  acl           = "private"
  bucket_name   = local.private_bucket_name
  domain        = module.env.domain_name
  force_destroy = module.env.not_production
  project_name  = local.project_name

  principal_arns = [
    module.user.arn,
    module.media_services.role_ecs.arn,
    module.media_services.role_ecs_task.arn,
  ]
}

module "loadbalancer" {
  source                      = "../../modules/aws/lb"
  additional_certificate_arns = []
  certificate_arn             = module.certificate.certificate_id
  domain                      = module.env.domain_name
  project_name                = local.project_name
  security_groups             = module.media_services.security_groups
  subnets                     = module.vpc.public.*.id
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
  availability_zones = module.vpc.availability_zones
  cluster_id         = module.cluster.cluster_id
  domain             = module.env.domain_name
  project_name       = local.project_name
  secret_resources   = [module.secrets.arn]
  subnets            = module.vpc.public.*.id
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
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

module "rds" {
  source                     = "../../modules/aws/rds"
  allowed_hosts              = local.allowed_hosts
  auto_minor_version_upgrade = true
  backup_retention_period    = 1
  backup_window              = "05:00-06:00"
  bucket_arn                 = module.private_bucket.arn
  database_identifier        = local.project_name
  database_name              = local.project_name
  db_subnet_group_name       = "db-subnet-group-${terraform.workspace}"
  disk_size                  = 32
  domain                     = module.env.domain_root
  engine                     = "mysql"
  engine_version             = "5.7.26"
  enable_monitoring          = true
  instance_class             = "db.t3.micro"
  kms_key_id                 = null
  maintenance_window         = "Sat:02:00-Sat:03:00"
  multi_az                   = false
  parameter_group            = "default.mysql5.7"
  password                   = random_string.database_password.result
  project_name               = local.project_name
  publicly_accessible        = true
  security_groups            = module.media_services.security_groups
  skip_final_snapshot        = module.env.not_production
  storage_encrypted          = module.env.is_production
  vpc_id                     = module.vpc.vpc_id
  vpc_security_group_ids     = []

  # DANGER: Only set this value when there is a disaster. Setting this
  # value *will* destroy and re-create from the specified snapshot.
  snapshot_identifier = null
}
