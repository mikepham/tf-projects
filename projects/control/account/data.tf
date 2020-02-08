data "aws_caller_identity" "current" {}

data "aws_route53_zone" "zones" {
  count = length(var.domains)
  name  = "${var.domains[count.index]}."
}
