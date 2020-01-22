variable "cluster_name" {
  default     = null
  description = "Cluster Name"
  type        = string
}

variable "container_port" {
  default     = 80
  description = "Container Service Port"
  type        = number
}

variable "container_port_ssl" {
  default     = 443
  description = "Container Service Port"
  type        = number
}

variable "database_port" {
  default     = 3306
  description = "Database Port"
  type        = number
}

variable "deployment_controller_type" {
  default     = "ECS"
  description = "Deployment Controller Type"
  type        = string
}

variable "deployment_maximum_percent" {
  default     = null
  description = "Deployment Maximum Percent"
  type        = number
}

variable "deployment_minimum_healthy_percent" {
  default     = null
  description = "Deployment Minimum Healthy Percent"
  type        = number
}

variable "desired_count" {
  default     = 1
  description = "Desired Instance Count"
  type        = number
}

variable "enabled" {
  default     = true
  description = "Determines if module is enabled"
  type        = bool
}

variable "enable_deletion_protection" {
  default     = false
  description = "Enable Deletion Protection"
  type        = bool
}

variable "enable_ecs_managed_tags" {
  default     = false
  description = "Enable ECS Managed Tags"
  type        = bool
}

variable "enable_logging" {
  default     = true
  description = "Enable Container Logging"
  type        = bool
}

variable "iam_role" {
  default     = null
  description = "IAM Role"
  type        = string
}

variable "load_balancer_type" {
  default     = "application"
  description = "Load Balancer Type"
  type        = string
}

variable "policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
  ]

  description = "Policies"
  type        = list(string)
}

variable "platform_version" {
  default     = "LATEST"
  description = "Platform Version"
  type        = string
}

variable "propagate_tags" {
  default     = null
  description = "Propogate Tags"
  type        = string
}

variable "retention_in_days" {
  default     = 90
  description = "Retention in Days"
  type        = number
}

variable "secret_resources" {
  default     = []
  description = "Secret Resources"
  type        = list(string)
}

variable "security_group_ids" {
  default     = []
  description = "Security Group IDs"
  type        = list(string)
}
