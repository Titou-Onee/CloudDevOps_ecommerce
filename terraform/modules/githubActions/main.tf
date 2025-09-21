data "tls_certificate" "github"{
    url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]

  tags = {
    Name = "github actions oidc"
  }
}

resource "aws_iam_role" "github" {
  name = "github-actions-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:Titou-Onee/CloudDevOpsProject:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name = "Github Actions role"
  }
}

resource "aws_iam_role_policy" "github_policy" {
  name = "github-action-permissions"
  role = aws_iam_role.github.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "eks:*",
                "ec2:Describe*",
                "iam:GetRole",
                "iam:PassRole",
                "iam:ListRoles",
                "iam:CreateServiceLinkedRole",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:TagRole",
                "autoscaling:*",
                "cloudformation:*",
                "elasticloadbalancing:*",
                "logs:*",
                "ssm:GetParameter",
                "ssm:GetParameters"
            ],
            Effect = "Allow"
            "Resource": "*"
        }
    ]
  })
}