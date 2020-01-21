variable "domain" {
  description = "Domain name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "subnets" {
  description = "Subnets to attach EFS"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC"
  type        = string
}

