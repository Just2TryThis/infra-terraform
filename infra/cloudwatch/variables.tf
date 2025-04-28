variable "bucket_name" {
  type        = string
  description = "Nom du bucket S3 déjà existant (ex: labbylab)"
}

variable "log_group_name" {
  type        = string
  description = "Nom du CloudWatch Logs group à exporter"
}
