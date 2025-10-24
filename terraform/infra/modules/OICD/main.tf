data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_infracost" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]

  tags = {
    Name = "github-actions-oidc-provider"
  }
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_infracost.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com", "https://github.com/${ var.git_orga_name }"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:titou-onee/clouddevops_ecommerce:*", "repo:${var.github_repo}:ref:refs/heads/master", "repo:${var.github_repo}:pull_request/*"] 
    }
  }
}

resource "aws_iam_role" "github_actions_tf_role" {
  name               = "GitHubOIDC-TF-Infracost-Role"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}

resource "aws_iam_policy" "infracost_readonly" {
  name        = "InfracostReadOnlyAccess"
  description = "Permissions minimales pour terraform plan et Infracost."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*", "s3:GetBucketLocation", "s3:ListAllMyBuckets", "s3:ListBucket",
          "iam:List*", "iam:Get*", "route53:Get*", "route53:List*", "rds:Describe*",
          "lambda:List*", "lambda:Get*", "dynamodb:DescribeTable", "dynamodb:ListTables",

          "pricing:GetProducts", "pricing:DescribeServices",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "infracost_access" {
  role       = aws_iam_role.github_actions_tf_role.name
  policy_arn = aws_iam_policy.infracost_readonly.arn
}