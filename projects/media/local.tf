locals {
  allowed_hosts            = ["97.106.33.210/32"]
  default_target_group_arn = length(module.phamflix.target_group_arns) > 0 ? module.phamflix.target_group_arns[0] : null
  domain                   = "nativecode.net"
  private_bucket_name      = "media.${module.env.domain_name}"
  project_name             = "media"
  region                   = "us-east-1"

  OMBI_DATABASE_JSON = {
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

  OMBI_MIGRATION_JSON = {
    OmbiDatabase = {
      ConnectionString = "Data Source=/config/Ombi.db"
      Type             = "sqlite"
    }

    SettingsDatabase = {
      ConnectionString = "DataSource=/config/OmbiSettings.db"
      Type             = "sqlite"
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
  }

  vpc = {
    availability_zones    = ["us-east-1a", "us-east-1b"]
    cidr_block            = "172.32.0.0/16"
    private_block_subnets = ["172.32.32.0/19", "172.32.64.0/19"]
    public_block_subnets  = ["172.32.160.0/19", "172.32.192.0/19"]
  }
}
