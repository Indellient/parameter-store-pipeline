output "ci_user_access_key_id" {
  value = aws_iam_access_key.ci_user_credentials.id
}

output "ci_user_access_secret_key" {
  value = aws_iam_access_key.ci_user_credentials.secret
}
