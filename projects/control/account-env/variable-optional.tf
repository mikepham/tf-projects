variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
  type        = string
}

variable "subdomains" {
  default     = []
  description = "Sub Domains"
  type        = list(string)
}
