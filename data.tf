data "aws_route53_zone" "root" {
  name = "nativecode.net."
}

data "aws_instance" "gitlab" {
  instance_id = "i-043ad64e07a6f4c82"
}

data "aws_instance" "wordpress" {
  instance_id = "i-02ed21990ad3f9f53"
}

data "template_file" "default" {
  template = file("${path.module}/definitions/default.json")
}

data "template_file" "nzbhydra" {
  template = file("${path.module}/definitions/nzbhydra.json")
}

data "template_file" "phamflix" {
  template = file("${path.module}/definitions/phamflix.json")
}

data "template_file" "jackett" {
  template = file("${path.module}/definitions/jackett.json")
}
