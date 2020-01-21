variable "algorithm" {
  default     = "RSA"
  description = "Algorithm"
  type        = string
}

variable "ecdsa_curve" {
  default     = "P224"
  description = "EC-DSA"
  type        = string
}

variable "rsa_bits" {
  default     = 4096
  description = "RSA bits"
  type        = string
}
