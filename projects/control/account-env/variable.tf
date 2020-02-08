variable "account_id" {
  description = "Account ID to trust"
  type        = string
}

variable "domains" {
  description = "Domains"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "users" {
  description = "Users"

  type = list(
    object(
      {
        import   = bool
        username = string
      }
    )
  )
}
