variable "allowed_hosts" {
  description = "Allowed Hosts"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availablity Zones"
  type        = list(string)
}

variable "cluster_id" {
  description = "ECS Cluster"
  type        = string
}

variable "containers" {
  description = "Container Services"

  type = list(object({
    cidr_blocks              = list(string)
    cpu                      = number
    definitions              = string
    desired_count            = number
    dns_name                 = string
    family                   = string
    health_check_path        = string
    launch_type              = string
    log_name                 = string
    memory                   = number
    name                     = string
    network_mode             = string
    port                     = number
    public_ip                = bool
    requires_compatibilities = list(string)
    security_groups          = list(string)
    volumes                  = list(any)
  }))
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "subnets" {
  description = "Subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
