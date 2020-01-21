variable "certificate_arn" {
  description = "Description ARN"
  type        = string
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "security_groups" {
  description = "AWS Security Groups"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target group to attach"
  type        = string
}

variable "vpc_id" {
  description = "VPC"
  type        = string
}

variable "module_depends_on" {
  type    = any
  default = null
}
