variable "env" {
  type        = string
  description = "Environment name (dev/staging/prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet"
}

variable "az_a" {
  type        = string
  description = "Availability zone for public subnet"
}

variable "az_b" {
  type        = string
  description = "Availability zone for private subnet"
}
