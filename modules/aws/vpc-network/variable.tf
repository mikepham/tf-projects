variable "availability_zones" {
  description = "Availablility Zones"
  type        = list(string)
}

variable "domain" {
  description = "Domain Name"
  type        = string
}

variable "enable_dns_hostnames" {
  default     = true
  description = "Enable DNS Hostnames"
  type        = bool
}

variable "enable_dns_support" {
  default     = true
  description = "Enable DNS Support"
  type        = bool
}

variable "instance_tenancy" {
  default     = "default"
  description = "Instance Tenancy"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "vpc_cidr_block_destination" {
  default     = "0.0.0.0/0"
  description = "VPC CIDR Block Destination"
  type        = string
}

variable "vpc_cidr_private_block_subnets" {
  description = "VPC CIDR Block Subnets"
  type        = list(string)
}

variable "vpc_cidr_public_block_subnets" {
  description = "VPC CIDR Block Subnets"
  type        = list(string)
}

variable "vpc_nat_private_ip" {
  description = "NAT Gateway Private IP"
  type        = string
}
