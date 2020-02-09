resource "random_string" "database_password" {
  length      = 24
  lower       = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 0
  number      = true
  upper       = true
  special     = false
}

resource "aws_route53_record" "domain" {
  name    = module.env.domain_name
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

resource "aws_route53_record" "domain-wildcard" {
  name    = "*.${module.env.domain_name}"
  type    = "A"
  zone_id = module.domain.zone_id

  alias {
    evaluate_target_health = true
    name                   = module.loadbalancer.dns_name
    zone_id                = module.loadbalancer.zone_id
  }
}

resource "local_file" "database-json" {
  content  = jsonencode(local.OMBI_DATABASE_JSON)
  filename = "${path.module}/.output/database.json"
}

resource "aws_s3_bucket_object" "database-json" {
  depends_on = [module.private_bucket, local_file.database-json]
  bucket     = local.private_bucket_name
  key        = "/ombi/config/database.json"
  source     = "${path.module}/.output/database.json"
}

resource "local_file" "migration-json" {
  content  = jsonencode(local.OMBI_MIGRATION_JSON)
  filename = "${path.module}/.output/migration.json"
}

resource "aws_s3_bucket_object" "migration-json" {
  depends_on = [module.private_bucket, local_file.migration-json]
  bucket     = local.private_bucket_name
  key        = "/ombi/config/migration.json"
  source     = "${path.module}/.output/migration.json"
}
