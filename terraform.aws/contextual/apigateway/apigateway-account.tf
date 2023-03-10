resource "aws_api_gateway_account" "sac_api_gateway_account" {

  # DEMO - severity change based on business impact Moderate -> High
  #cloudwatch_role_arn = aws_iam_role.sac_api_gateway_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.sac_api_gateway_policy_attachment,
    aws_iam_role_policy.sac_api_gateway_role_policy
  ]
}

resource "aws_iam_role" "sac_api_gateway_role" {
  name = "sac-testing-apigw-cloudwatch-role"

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
      "Action": "sts:AssumeRole",
      "Resource": "${aws_api_gateway_rest_api.sac_api_gateway_rest_api.execution_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sac_api_gateway_role_policy" {
  name = "sac-testing-apigw-cloudwatch-role-policy"
  role = aws_iam_role.sac_api_gateway_role.id

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
            "Resource": "${aws_api_gateway_rest_api.sac_api_gateway_rest_api.execution_arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sac_api_gateway_policy_attachment" {
  role       = aws_iam_role.sac_api_gateway_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}