resource "aws_security_group" "gitlab" {
  description = "Allow ECS Task Access"
  name        = "gitlab"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name    = local.domain
    Project = local.project_name
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "gitlab" {
  ami                         = local.ami_gitlab
  associate_public_ip_address = false
  instance_type               = "t2.medium"
  key_name                    = module.keypair.key_name
  security_groups             = [aws_security_group.gitlab.id]
  subnet_id                   = module.vpc.private[0].id

  tags = {
    Name    = local.domain
    Project = local.project_name
  }

  root_block_device {
    volume_size = 30
  }
}
