resource "random_string" "database_password_ombi" {
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

resource "mysql_database" "ombi" {
  name = local.secrets.DB_OMBI
}

resource "mysql_user" "ombi" {
  host               = "%"
  plaintext_password = local.secrets.DB_OMBI_PASSWORD
  user               = mysql_database.ombi.name
}

resource "mysql_grant" "admin" {
  user       = local.secrets.DB_USERNAME
  host       = local.secrets.DB_HOSTNAME
  database   = mysql_database.ombi.name
  privileges = ["ALL"]
}

resource "mysql_grant" "ombi" {
  depends_on = [mysql_user.ombi]
  user       = mysql_database.ombi.name
  host       = local.secrets.DB_HOSTNAME
  database   = mysql_database.ombi.name
  privileges = ["ALL"]
}
