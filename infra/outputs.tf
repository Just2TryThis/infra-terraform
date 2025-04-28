output "instance_ip_addr" {
  value = module.ec2_instance.instance_ip_addr
}

output "sops_kms_key_arn" {
  description = "The ARN of the KMS key created by the kms module"
  value       = module.sops_kms.key_arn
}

output "kungfu_access_key_id" {
  description = "Access key ID for kungfu user"
  value       = module.iam.access_key_id
}

output "kungfu_secret_access_key" {
  description = "Secret access key for kungfu user"
  value       = module.iam.access_key_secret
  sensitive   = true
}

output "kungfu_username" {
  description = "IAM username"
  value       = module.iam.username
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "igw_id" {
  value = module.network.internet_gateway_id
}

output "public_route_table_id" {
  value = module.network.public_route_table_id
}

