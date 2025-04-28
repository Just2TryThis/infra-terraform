variable "bucket_name" {
  description = "Nom du bucket principal"
  type        = string
}

variable "is_multi_region" {
  type        = bool
  default     = false
  description = "Active CloudTrail multi-régions"
}

