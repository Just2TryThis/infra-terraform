output "admin_group_name" {
  value = aws_iam_group.superuser.name
}

output "reader_group_name" {
  value = aws_iam_group.reader.name
}
