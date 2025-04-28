resource "aws_secretsmanager_secret" "kungfu_access_keys" {
  name        = "kungfu-access-keys_v5"
  description = "Stores IAM access keys for kungfu user securely."

  tags = {
    Name = "kungfu-access-keys"
    Environment = "dev"
  }
}

resource "aws_secretsmanager_secret_version" "kungfu_access_keys_version" {
  secret_id     = aws_secretsmanager_secret.kungfu_access_keys.id
  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.kungfu_access_key.id,
    secret_access_key = aws_iam_access_key.kungfu_access_key.secret
  })
}
