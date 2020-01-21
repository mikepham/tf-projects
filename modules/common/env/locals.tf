locals {
  domain_name = var.dns_host_name == null ? "${terraform.workspace}.${var.domain}" : "${var.dns_host_name}.${terraform.workspace}.${var.domain}"
  domain_root = var.domain
  domain_slug = replace(local.domain_name, ".", "-")

  env_domain_name = var.dns_host_name == null ? local.domain_name : "${terraform.workspace}.${var.domain}"
  env_domain_slug = replace(local.env_domain_name, ".", "-")
  env_name        = terraform.workspace

  is_dev        = local.env_name == "dev"
  is_stage      = local.env_name == "stage"
  is_production = local.env_name == "prod"

  not_dev        = local.env_name != "dev"
  not_stage      = local.env_name != "stage"
  not_production = local.env_name != "prod"
}
