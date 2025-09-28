variable "region" {
  type        = string
  description = "region"
}

variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type = string
}

variable "public_cidr" {
  description = "Subnet public cidr"
  type = list(string)
}

variable "private_cidr" {
  description = "Subnet private cidr"
  type = list(string)
}