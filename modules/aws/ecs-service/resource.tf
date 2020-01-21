data "aws_iam_policy_document" "ecs" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["ecs-tasks.amazonaws.com", "iam.amazonaws.com", "s3.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    actions = [
      "iam:GetUser",
      "secretsmanager:GetSecretValue",
    ]
    effect    = "Allow"
    resources = length(var.secret_resources) > 0 ? var.secret_resources : ["*"]
  }
}

resource "aws_iam_policy" "permissions" {
  count       = var.enabled ? 1 : 0
  description = "ECS Permissions"
  name_prefix = "${local.cluster_name}-"
  policy      = data.aws_iam_policy_document.permissions.json
}

resource "aws_iam_role" "ecs" {
  count              = var.enabled ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.ecs.json
  name               = "role-ecs-${replace(var.domain, ".", "-")}"
}

resource "aws_iam_role" "task" {
  count              = var.enabled ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.ecs.json
  name               = "role-task-${replace(var.domain, ".", "-")}"
}

resource "aws_iam_role_policy_attachment" "ecs" {
  count      = var.enabled ? length(var.policies) : 0
  role       = aws_iam_role.ecs[0].name
  policy_arn = var.policies[count.index]
}

resource "aws_iam_role_policy_attachment" "task" {
  count      = var.enabled ? length(var.policies) : 0
  role       = aws_iam_role.task[0].name
  policy_arn = var.policies[count.index]
}

resource "aws_security_group" "tasks" {
  count       = var.enabled ? 1 : 0
  description = "Allow ECS Task Access"
  name_prefix = "${local.cluster_name}-"
  vpc_id      = var.vpc_id

  tags = {
    Name    = var.domain
    Project = var.project_name
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  dynamic "ingress" {
    iterator = container
    for_each = var.containers

    content {
      cidr_blocks     = lookup(container.value, "cidr_blocks", [])
      protocol        = lookup(container.value, "protocol", "tcp")
      from_port       = lookup(container.value, "from_port", lookup(container.value, "port", 0))
      to_port         = lookup(container.value, "to_port", lookup(container.value, "port", 0))
      security_groups = lookup(container.value, "security_groups", var.security_group_ids)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "ecs" {
  count       = var.enabled ? length(var.containers) : 0
  name_prefix = "tgt-"
  port        = lookup(var.containers[count.index], "port", null)
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    matcher = lookup(var.containers[count.index], "health_check_matcher", "200,302")
    path    = lookup(var.containers[count.index], "health_check_path", null)
    port    = lookup(var.containers[count.index], "health_check_port", lookup(var.containers[count.index], "port", null))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_task_definition" "ecs" {
  count                    = var.enabled ? length(var.containers) : 0
  container_definitions    = var.containers[count.index].definitions
  cpu                      = var.containers[count.index].cpu
  execution_role_arn       = aws_iam_role.ecs[0].arn
  memory                   = var.containers[count.index].memory
  family                   = var.containers[count.index].family
  network_mode             = var.containers[count.index].network_mode
  requires_compatibilities = var.containers[count.index].requires_compatibilities
  task_role_arn            = aws_iam_role.task[0].arn

  dynamic "volume" {
    for_each = var.containers[count.index].volumes

    content {
      name      = lookup(volume.value, "name", null)
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])

        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }
    }
  }
}

resource "aws_ecs_service" "ecs" {
  count                              = var.enabled ? length(var.containers) : 0
  cluster                            = var.cluster_id
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.containers[count.index].desired_count
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  iam_role                           = var.iam_role
  launch_type                        = var.containers[count.index].launch_type
  propagate_tags                     = var.propagate_tags
  name                               = var.containers[count.index].name
  platform_version                   = var.platform_version
  task_definition                    = aws_ecs_task_definition.ecs[count.index].arn

  deployment_controller {
    type = var.deployment_controller_type
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  load_balancer {
    container_name   = var.containers[count.index].name
    container_port   = var.containers[count.index].port
    target_group_arn = aws_lb_target_group.ecs[count.index].arn
  }

  network_configuration {
    assign_public_ip = var.containers[count.index].public_ip
    security_groups  = length(var.containers[count.index].security_groups) == 0 ? [aws_security_group.tasks[0].id] : var.containers[count.index].security_groups
    subnets          = var.subnets
  }
}

resource "aws_cloudwatch_log_group" "log" {
  count             = var.enabled ? length(var.containers) : 0
  name              = var.containers[count.index].log_name
  retention_in_days = var.retention_in_days

  tags = {
    Container = var.containers[count.index].name
    Name      = var.domain
    Project   = var.project_name
  }
}
