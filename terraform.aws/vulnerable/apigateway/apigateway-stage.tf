resource "aws_api_gateway_stage" "sac_api_gateway_stage" {
  deployment_id         = aws_api_gateway_deployment.sac_api_gateway_deployment.id  # Required
  rest_api_id           = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id  # Required
  stage_name            = "sac-testing-apigw-stage"   # Required

  depends_on = [
    aws_api_gateway_account.sac_api_gateway_account
  ]
}

resource "aws_cloudwatch_log_group" "sac_api_gateway_cloudwatch_log_group" {
  name = "sac-testing-apigw-cloudwatch-log-group"

  tags = {
    Environment = "production"
  }
}