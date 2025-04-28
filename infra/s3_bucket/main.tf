resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "labbylab"
  }
}

resource "aws_s3_bucket_public_access_block" "this_block" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "very_secret_upload" {
  bucket = aws_s3_bucket.this.id
  key    = "very_secret_file.txt"

  content = templatefile("${path.module}/very_secret_file.tpl.txt", {
    username = var.very_secret_username,
    secret   = var.very_secret_access_key_secret,
    id       = var.very_secret_access_key_id
  })
}
