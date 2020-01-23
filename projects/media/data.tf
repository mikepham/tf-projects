data "template_file" "default" {
  template = file("definitions/default.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}

data "template_file" "nzbhydra" {
  template = file("definitions/nzbhydra.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}

data "template_file" "phamflix" {
  template = file("definitions/phamflix.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}

data "template_file" "jackett" {
  template = file("definitions/jackett.json")

  vars = {
    secret_name = "SECRETS"
    secret_arn  = module.secrets.arn
  }
}
