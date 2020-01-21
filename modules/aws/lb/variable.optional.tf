variable "additional_certificate_arns" {
  default     = []
  description = "Additional Certificates"
  type        = list(string)
}

variable "enable_deletion_protection" {
  default     = false
  description = "Enable Deletion Protection"
  type        = bool
}

variable "listener_port" {
  default     = 80
  description = "Load balancer listening port"
  type        = string
}

variable "listener_protocol" {
  default     = "HTTP"
  description = "Load balancer listening protocol"
  type        = string
}

variable "listener_secure_port" {
  default     = 443
  description = "Load balancer listening secure port"
  type        = string
}

variable "listener_secure_protocol" {
  default     = "HTTPS"
  description = "Load balancer listening secure protocol"
  type        = string
}

variable "load_balancer_type" {
  default     = "application"
  description = "Load Balancer Type"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "rules" {
  default     = []
  description = "Load Balancer Rules"

  type = list(object({
    host_header      = list(string)
    target_group_arn = string
  }))
}

variable "target_group_arns" {
  default     = []
  description = "Target groups to attach"
  type        = list(string)
}
