resource "aws_iam_role" "firehose_role" {
  name = "firehose-to-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "firehose.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_kinesis_firehose_delivery_stream" "cw_to_s3" {
  name        = "cloudwatch-to-s3"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = "arn:aws:s3:::${var.bucket_name}"
    compression_format = "GZIP"
    prefix             = "cloudwatch-metrics/"

  }
depends_on = [
    aws_iam_role_policy.firehose_policy  # Assurer que la policy est bien appliquée avant Firehose
  ]
}

resource "aws_cloudwatch_metric_stream" "cpu_usage" {
  name           = "metric-stream"
  firehose_arn   = aws_kinesis_firehose_delivery_stream.cw_to_s3.arn
  role_arn       = aws_iam_role.cw_metric_stream_role.arn
  output_format  = "json"

  include_filter {
    namespace = "AWS/EC2"
    metric_names = ["NetworkOut"]  # La métrique que tu veux suivre
  }

  depends_on = [
    aws_kinesis_firehose_delivery_stream.cw_to_s3
  ]
}

resource "aws_iam_role_policy" "firehose_policy" {
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ],
        Resource = [
          # Important d’autoriser lister le bucket lui-même
          "arn:aws:s3:::${var.bucket_name}",
          # Et mettre/obtenir des objets dans le préfix
          "arn:aws:s3:::${var.bucket_name}/cloudwatch-metrics/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role" "cw_metric_stream_role" {
  name = "cw-metric-stream-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "streams.metrics.cloudwatch.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cw_metric_stream_policy" {
  role = aws_iam_role.cw_metric_stream_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        # Autorise CloudWatch à envoyer les métriques vers Firehose
        Effect = "Allow",
        Action = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        Resource = aws_kinesis_firehose_delivery_stream.cw_to_s3.arn
      }
    ]
  })
}
