resource "aws_iam_group" "sac_iam_group" {
  name = "sac-iam-group"
  path = "/users/"
}

resource "aws_iam_group_policy" "sac_iam_group_policy" {
  name  = "sac-iam-group-policy"
  group = aws_iam_group.sac_iam_group.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}