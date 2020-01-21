variable "domain" {
  description = "Domain Name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "secret_name" {
  description = "Secret Name"
  type        = string
}

variable "secrets" {
  type = map
}
