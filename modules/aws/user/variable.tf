variable "domain" {
  description = "Domain Name"
  type        = string
}

variable "group_name" {
  description = "Group Name"
  type        = string
}

variable "policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]

  description = "Policies"
  type        = list(string)
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "user_name" {
  description = "User Name"
  type        = string
}
