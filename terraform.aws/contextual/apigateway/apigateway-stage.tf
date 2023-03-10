resource "aws_api_gateway_stage" "sac_api_gateway_stage" {
  deployment_id         = aws_api_gateway_deployment.sac_api_gateway_deployment.id  
  rest_api_id           = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id  
  stage_name            = "sac-testing-apigw-stage"   

  # DEMO - severity change based on data sensitivity Moderate -> Critical
  # access_log_settings {
  #   destination_arn = aws_cloudwatch_log_group.sac_api_gateway_cloudwatch_log_group.arn
  #   format          = "$context.requestId"
  # }

  tags = {
    Environment = "production"
  }

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