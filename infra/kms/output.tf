output "key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.this.arn
}

output "alias_name" {
  description = "The alias of the KMS key"
  value       = aws_kms_alias.this.name
}
