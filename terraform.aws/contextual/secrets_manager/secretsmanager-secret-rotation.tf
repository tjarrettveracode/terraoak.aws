resource "aws_secretsmanager_secret_rotation" "secrets_manager_rotation" {
   secret_id = aws_secretsmanager_secret.sac_secrets_manager_insecure.id   # Required
   rotation_lambda_arn = aws_lambda_function.secure_lambda_SAC.arn   # Required

   rotation_rules {
    # SaC Testing - Severity: Critical - set automatically_after_days to value other than 30
     automatically_after_days = 30
   }
}

resource "aws_lambda_function" "secure_lambda_SAC" {
  function_name = "secure_lambda_function"   # Required
  role = aws_iam_role.lambda_role.arn     # Required
	filename   = "my-deployment-package.zip"   # Set this or imageURI
  handler = "index.handler"
  runtime = "dotnet6"
  reserved_concurrent_executions = 2
  kms_key_arn = aws_kms_key.sac_kms_key.arn
	
  tags = {
    Name = "foo function"
  }

  vpc_config {
    subnet_ids = [aws_subnet.test-subnet.id]	# Required
    security_group_ids = [aws_security_group.security-group-lambda.id]		# Required
  }

  dead_letter_config {
    target_arn = aws_sns_topic.topic-sns.arn		# Required
  }
}

resource "aws_sns_topic" "topic-sns" {
  name = "user-updates-topic"
}

resource "aws_security_group" "security-group-lambda" {
  # ... other configuration ...
  vpc_id     = aws_vpc.main.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_subnet" "test-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",

      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage",
          "sns:Publish"
          
        ]
        Effect   = "Allow",
        Resource = "${aws_secretsmanager_secret.sac_secrets_manager_insecure.arn}"
      },
    ]
  })
}

resource "aws_lambda_permission" "rotation_lambda_permission" {
  function_name = aws_lambda_function.secure_lambda_SAC.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}