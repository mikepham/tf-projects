resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  tags = {
    Name    = var.cluster_name
    Project = var.project_name
  }

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}
