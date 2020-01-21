output "permissions_arn" {
  value = aws_iam_policy.permissions[0].arn
}

output "role_ecs_arn" {
  value = aws_iam_role.ecs[0].arn
}

output "role_ecs_id" {
  value = aws_iam_role.ecs[0].id
}

output "role_ecs_task_arn" {
  value = aws_iam_role.task[0].arn
}

output "role_ecs_task_id" {
  value = aws_iam_role.task[0].id
}

output "port" {
  value = var.container_port
}

output "security_groups" {
  value = local.security_groups
}

output "target_group_arns" {
  value = aws_lb_target_group.ecs[*].arn
}
