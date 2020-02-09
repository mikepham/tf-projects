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
