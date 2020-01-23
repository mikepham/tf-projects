variable "algorithm" {
  default     = "RSA"
  description = "SSH KeyPair algorithm"
  type        = string
}

variable "bucket_name" {
  description = "Bucket name"
  type        = string
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "rsa_bits" {
  default     = 4096
  description = "Length of RSA KeyPair"
  type        = string
}
