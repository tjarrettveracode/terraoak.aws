resource "aws_api_gateway_usage_plan" "sac_api_gateway_usage_plan" {
  name         = "sac-testing-apigw-usage-plan" 
  
  api_stages {
    api_id = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id   
    stage  = aws_api_gateway_stage.sac_api_gateway_stage.stage_name 
  }
}