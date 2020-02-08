variable "domains" {
  description = "Domains"
  type        = list(string)
}

variable "envdomains" {
  type = list(
    object(
      {
        name = string, name_servers = list(string)
      }
    )
  )
}
