variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "KMS key for SOPS"
}

variable "deletion_window_in_days" {
  description = "Days before the KMS key is deleted"
  type        = number
  default     = 10
}

variable "enable_key_rotation" {
  description = "Whether to enable key rotation"
  type        = bool
  default     = true
}

variable "alias" {
  description = "Alias name for the KMS key"
  type        = string
  default     = "alias/sops-key"
}