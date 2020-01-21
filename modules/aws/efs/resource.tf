resource "aws_security_group" "efs" {
  name_prefix = "efs-"
  description = "Allows efs traffic from instances within the VPC."
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
  }

  tags = {
    Name    = var.domain
    Project = var.project_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "efs-${var.domain}"

  tags = {
    Name    = var.domain
    Project = var.project_name
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count = length(var.subnets)

  depends_on = [
    aws_efs_file_system.efs,
    aws_security_group.efs,
  ]

  file_system_id  = aws_efs_file_system.efs.id
  security_groups = aws_security_group.efs.*.name
  subnet_id       = var.subnets[count.index]
}
