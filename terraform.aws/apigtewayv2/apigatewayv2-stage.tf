resource "aws_apigatewayv2_stage" "sac_apigwv2_stage" {
  api_id = aws_apigatewayv2_api.sac_apigwv2_api.id
  name   = "sac-testing-apigwv2-stage"
}

resource "aws_cloudwatch_log_group" "sac_api_gatewayv2_cloudwatch_log_group" {
  name = "sac-testing-apigwv2-cloudwatch-log-group"

  tags = {
    Environment = "production"
  }
}