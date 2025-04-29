
# Fichier : ec2_instance/role.tf

# 1. Data policy pour assumer un rôle EC2
data "aws_iam_policy_document" "kungfu_ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# 2. Rôle IAM pour l'instance EC2
resource "aws_iam_role" "kungfu_role" {
  name                 = "tf-kungfu-role"
  assume_role_policy   = data.aws_iam_policy_document.kungfu_ec2_assume_role_policy.json
  permissions_boundary = var.permissions_boundary_arn

  tags = {
    Name = "tf-kungfu-role"
  }
}

# 3. Instance Profile pour l'EC2
resource "aws_iam_instance_profile" "kungfu_instance_profile" {
  name = "tf-kungfu-instance-profile"
  role = aws_iam_role.kungfu_role.name
}

# 4. Politique d'accès pour EC2 vers S3 et CloudWatch
resource "aws_iam_policy" "kungfu_ec2_restricted_policy" {
  name        = "kungfu-ec2-restricted-policy"
  description = "Restricted policy for EC2 access to specific S3 bucket and CloudWatch logs."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::labbylab",
          "arn:aws:s3:::labbylab/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# 5. Attacher la politique au rôle EC2
resource "aws_iam_role_policy_attachment" "attach_restricted_policy" {
  role       = aws_iam_role.kungfu_role.name
  policy_arn = aws_iam_policy.kungfu_ec2_restricted_policy.arn
}



#resource "aws_iam_role" "kungfu_role" {
#  name = "tf-${var.instance_name}-role"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = "sts:AssumeRole"
#        Effect = "Allow"
#        Sid    = ""
#        Principal = {
#          Service = "ec2.amazonaws.com"
#        }
#      },
#    ]
#  })
#}

#resource "aws_iam_role_policy" "kungfu_role_policy" {
#  name = "tf-${var.instance_name}-policy"
#  role = aws_iam_role.kungfu_role.id
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "s3:List*",
#          "s3:Get*",
#          "s3:Describe*"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#    ]
# })
#}
