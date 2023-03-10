resource "aws_lambda_function" "sac_api_gateway_lambda_function" {
  filename      = "${path.module}/foo.zip"
  function_name = "sac-testing-apigw-lambda"
  role          = aws_iam_role.sac_api_gateway_role.arn

  runtime = "nodejs12.x"
  handler = "index.test"
}