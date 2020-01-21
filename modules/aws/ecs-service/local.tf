locals {
  cluster_name    = coalesce(var.cluster_name, var.domain)
  security_groups = aws_security_group.tasks[*].id
}
