# resource "aws_route53_record" "jackett" {
#   name           = "*"
#   records        = [var.dns_name]
#   set_identifier = "prod"
#   ttl            = "300"
#   type           = "CNAME"
#   zone_id        = data.aws_route53_zone.zone.id

#   weighted_routing_policy {
#     weight = 90
#   }
# }
