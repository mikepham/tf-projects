resource "aws_security_group" "default" {
  description = "Default Load Balancer Security Group"
  name        = var.domain
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_lb" "lb" {
  name = replace(var.domain, ".", "-")

  enable_deletion_protection = var.enable_deletion_protection
  load_balancer_type         = var.load_balancer_type
  security_groups            = concat(var.security_groups, [aws_security_group.default.id])
  subnets                    = var.subnets
  depends_on                 = [var.module_depends_on]

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.listener_secure_port
      protocol    = var.listener_secure_protocol
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  certificate_arn   = var.certificate_arn
  load_balancer_arn = aws_lb.lb.arn
  port              = var.listener_secure_port
  protocol          = var.listener_secure_protocol

  default_action {
    target_group_arn = var.target_group_arn
    type             = "forward"
  }

  dynamic "default_action" {
    iterator = action
    for_each = var.target_group_arns

    content {
      target_group_arn = action.value
      type             = "forward"
    }
  }
}

resource "aws_lb_listener_certificate" "certificate" {
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}

resource "aws_lb_listener_rule" "host_based_routing" {
  count        = length(var.rules)
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = var.rules[count.index].target_group_arn
  }

  condition {
    field  = "host-header"
    values = var.rules[count.index].host_header
  }
}
