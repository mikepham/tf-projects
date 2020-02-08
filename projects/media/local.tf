locals {
  allowed_hosts                  = ["97.106.33.210/32"]
  availability_zones             = ["us-east-1a", "us-east-1b"]
  domain                         = "nativecode.net"
  private_bucket_name            = "private.${module.env.domain_name}"
  project_name                   = "media"

  secrets = {
    AWS_ACCESS_KEY_ID     = module.user.access_key
    AWS_SECRET_ACCESS_KEY = module.user.secret_key
    DB                    = local.project_name
    DB_ARN                = module.rds.arn
    DB_HOSTNAME           = module.rds.address
    DB_USERNAME           = "admin"
    DB_PASSWORD           = random_string.database_password.result
  }
}
