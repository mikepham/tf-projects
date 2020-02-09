locals {
  allowed_hosts       = ["97.106.33.210/32"]
  domain              = "nativecode.net"
  private_bucket_name = "private.${module.env.domain_name}"
  project_name        = "media"

  ombi_database_json = {
    ExternalDatabase = {
      ConnectionString = "Server=${module.rds.address}; Port=3306; Database=ombi; User=admin; Password=\"${random_string.database_password.result}\""
      Type             = "MySQL"
    }

    OmbiDatabase = {
      ConnectionString = "Server=${module.rds.address}; Port=3306; Database=ombi; User=admin; Password=\"${random_string.database_password.result}\""
      Type             = "MySQL"
    }

    SettingsDatabase = {
      ConnectionString = "Server=${module.rds.address}; Port=3306; Database=ombi; User=admin; Password=\"${random_string.database_password.result}\""
      Type             = "MySQL"
    }
  }

  secrets = {
    AWS_ACCESS_KEY_ID     = module.user.access_key
    AWS_SECRET_ACCESS_KEY = module.user.secret_key

    DB          = local.project_name
    DB_ARN      = module.rds.arn
    DB_HOSTNAME = module.rds.address
    DB_USERNAME = "admin"
    DB_PASSWORD = random_string.database_password.result

    DB_OMBI          = "ombi"
    DB_OMBI_PASSWORD = random_string.database_password_ombi.result
    DB_OMBI_USERNAME = "ombi"
  }
}
