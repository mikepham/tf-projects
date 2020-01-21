output "permissions_arn" {
  value = aws_iam_policy.permissions[*].arn
}

output "role_ecs_arn" {
  value = aws_iam_role.ecs[*].arn
}

output "role_ecs_id" {
  value = aws_iam_role.ecs[*].id
}

output "role_ecs_task_arn" {
  value = aws_iam_role.task[*].arn
}

output "role_ecs_task_id" {
  value = aws_iam_role.task[*].id
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
