resource "aws_iam_policy" "kungfu_permissions_boundary" {
  name        = "kungfu-permissions-boundary"
  description = "Permissions boundary to restrict IAM roles actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:Describe*",
          "kms:Decrypt"
        ]
        Resource = "*"
      },
      {
        Effect = "Deny"
        Action = "iam:*"
        Resource = "*"
      }
    ]
  })
}

#resource "aws_iam_role" "kungfu_role" {
#  name               = "tf-kungfu-role"
#  assume_role_policy = data.aws_iam_policy_document.kungfu_ec2_assume_role_policy.json
#  permissions_boundary = aws_iam_policy.kungfu_permissions_boundary.arn
#}

