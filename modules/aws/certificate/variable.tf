variable "cert_domain" {
  description = "Certificate Domain Name"
  type        = string
}

variable "cert_domain_alts" {
  default     = []
  description = "Certificate domain names to create"
  type        = list(string)
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "validation_method" {
  default     = "DNS"
  description = "DNS Validation Method"
  type        = string
}

variable "zone_id" {
  description = "Zone Id"
  type        = string
}
