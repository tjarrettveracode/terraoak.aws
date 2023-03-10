resource "aws_api_gateway_method_settings" "api_gateway_method_settings" {
  # All options # Must be configured
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.api_gateway_stage.stage_name
  method_path = "*/*"
  settings {
    cache_data_encrypted   = false
    data_trace_enabled     = true
    caching_enabled        = true
    metrics_enabled        = true
    logging_level          = "ERROR"
    throttling_burst_limit = 10
    throttling_rate_limit  = 10
  }
}

resource "aws_api_gateway_usage_plan" "api_gateway_usage_plan" {
  name         = "ApiGateway-usage-plan"
  description  = "my foo usage plan"
  product_code = "MYCODE"

  api_stages {
    # All options # Must be configured
    api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
    stage  = aws_api_gateway_stage.api_gateway_stage.stage_name
  }

  quota_settings {
    # All options # Must be configured
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    # All options # Must be configured
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_role.arn # Must be configured
  depends_on = [
    aws_iam_role_policy_attachment.api_gateway_role_attachment,
    aws_iam_role_policy.api_gateway_role_policy
  ]
}

resource "aws_iam_role" "api_gateway_role" {
  name = "ApiGateway-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": ["apigateway.amazonaws.com","lambda.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "api_gateway_role_policy" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy" "api_gateway_role_policy" {
  name = "default"
  role = aws_iam_role.api_gateway_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
