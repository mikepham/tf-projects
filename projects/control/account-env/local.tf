locals {
  users = {
    create  = [for user in var.users : user.import == false]
    imports = [for user in var.users : user.import == true]
  }
}
