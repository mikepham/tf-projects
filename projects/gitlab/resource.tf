resource "aws_security_group" "gitlab" {
  description = "Allow ECS Task Access"
  name        = "gitlab"
  vpc_id      = module.vpc.vpc_id

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

resource "aws_instance" "gitlab" {
  ami             = local.ami_gitlab
  instance_type   = "t2.medium"
  security_groups = []

  tags = {
    Name    = local.domain
    Project = local.project_name
  }

  root_block_device {
    volume_size = 30
  }
}
