variable "my_ip" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to attach the EC2 to"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to attach the security group"
}

variable "permissions_boundary_arn" {
  description = "ARN of the IAM permissions boundary to attach to roles"
  type        = string
}




