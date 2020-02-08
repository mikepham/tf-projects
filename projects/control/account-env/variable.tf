variable "account_id" {
  description = "Account ID to trust"
  type        = string
}

variable "developers" {
  description = "Developer users"
  type        = list(string)
}

variable "devops" {
  description = "DevOps users"
  type        = list(string)
}

variable "domains" {
  description = "Domains"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "operators" {
  description = "Operations users"
  type        = list(string)
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
  type        = string
}

variable "rolemap" {
  type = map(
    object({
      developers = list(string)
      devops     = list(string)
      operators  = list(string)
    })
  )
}

variable "subdomains" {
  default     = []
  description = "Sub Domains"
  type        = list(string)
}

variable "zones" {
  type = list(object({ name = string, zone_id = string }))
}
