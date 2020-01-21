data "template_file" "default" {
  template = file("${path.module}/definitions/default.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}

data "template_file" "nzbhydra" {
  template = file("${path.module}/definitions/nzbhydra.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}

data "template_file" "phamflix" {
  template = file("${path.module}/definitions/phamflix.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}

data "template_file" "jackett" {
  template = file("${path.module}/definitions/jackett.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}
