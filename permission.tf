locals {
  iam_group_name = "Linux-Admin"
}

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
  group      = local.iam_group_name
  policy_arn = aws_iam_policy.allow_get_secret_value.arn
}

resource "aws_iam_group_policy" "linux_admin_mfa_policy" {
  group = local.iam_group_name
  name  = "LinuxAdminEnforceMFA"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "DenyAllExceptSpecifiedActionsIfNoMFA",
        Effect = "Deny",
        NotAction = [
          "iam:GetAccountPasswordPolicy",
          "iam:ChangePassword",
          "sts:GetSessionToken",
          "sts:AssumeRole" # Allow assuming roles for MFA setup
        ],
        Resource = "*",
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" : "false"
          }
        }
      }
    ]
  })
}