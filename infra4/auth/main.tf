resource "aws_iam_group" "reader" {
  name = "reader"
}

resource "aws_iam_group" "superuser" {
  name = "superuser"
}

resource "aws_iam_group_policy_attachment" "reader_policy_attachment" {
  group      = aws_iam_group.reader.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "admin_policy_attachment" {
  group      = aws_iam_group.superuser.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
