resource "aws_iam_user" "kungfu_user" {
  name          = "tf-${var.username}-user"
  force_destroy = true
}

resource "aws_iam_access_key" "kungfu_access_key" {
  user = aws_iam_user.kungfu_user.name
}

data "aws_iam_policy" "full_read_only_policy" {
  name = "ReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "attach_full_read_only" {
  name       = "tf-attach-readonly"
  users      = [aws_iam_user.kungfu_user.name]
  policy_arn = data.aws_iam_policy.full_read_only_policy.arn
}

data "aws_iam_policy_document" "kms_access_for_kungfu" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      var.kms_key_arn
    ]
  }
}

resource "aws_iam_policy" "kungfu_kms_policy" {
  name   = "tf-kungfu-kms-policy"
  policy = data.aws_iam_policy_document.kms_access_for_kungfu.json
}

resource "aws_iam_user_policy_attachment" "attach_kms_to_kungfu" {
  user       = aws_iam_user.kungfu_user.name
  policy_arn = aws_iam_policy.kungfu_kms_policy.arn
}

resource "aws_iam_user_policy" "kungfu_policy" {
  name = "tf-${var.policy_name}-policy"
  user = aws_iam_user.kungfu_user.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:AttachUserPolicy",
          "iam:CreateUser"
        ],
        "Resource" : [
          "arn:aws:iam::421751520950:user/fake-admin*",
          "arn:aws:iam::421751520950:policy/tf-fake-admin-policy"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "fake_admin_policy" {
  name = "tf-fake-admin-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances" # TODO : A CHANGER
        ],
        "Resource" : "*"
      }
    ]
  })
}