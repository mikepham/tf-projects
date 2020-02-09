resource "random_string" "database_password_ombi" {
  length      = 16
  lower       = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  number      = true
  upper       = true
  special     = true
}

resource "mysql_database" "ombi" {
  name = local.secrets.DB_OMBI
}

resource "mysql_user" "ombi" {
  host               = "%"
  plaintext_password = local.secrets.DB_OMBI_PASSWORD
  user               = mysql_database.ombi.name
}

resource "mysql_grant" "admin" {
  database   = mysql_database.ombi.name
  host       = local.secrets.DB_HOSTNAME
  privileges = ["ALL"]
  user       = local.secrets.DB_USERNAME
}

resource "mysql_grant" "ombi" {
  database   = mysql_database.ombi.name
  host       = local.secrets.DB_HOSTNAME
  privileges = ["ALL"]
  user       = mysql_user.ombi.user
}
