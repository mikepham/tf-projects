locals {
  defaults = { developers = [], devops = [], operators = [] }
  rolemaps = lookup(var.rolemap, var.environment, local.defaults)

  developer_roles = lookup(local.rolemaps, "developers", local.defaults)
  devops_roles    = lookup(local.rolemaps, "devops", local.defaults)
  operator_roles  = lookup(local.rolemaps, "operators", local.defaults)
}
