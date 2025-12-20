resource "aws_iam_policy" "allow_get_secret_value" {
  name        = "AllowGetSecretValue"
  description = "Policy to allow GetSecretValue access to the ec2_private_key secret"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = aws_secretsmanager_secret.ec2_private_key.arn
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "attach_get_secret_policy" {
  group      = data.aws_iam_group.linux_admin.id
  policy_arn = aws_iam_policy.allow_get_secret_value.arn
}
