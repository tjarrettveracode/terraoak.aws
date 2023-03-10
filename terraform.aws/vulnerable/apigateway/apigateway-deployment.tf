resource "aws_api_gateway_deployment" "sac_api_gateway_deployment" {
  rest_api_id       = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id
  description       = "SaC testing api-gw deployment"
  stage_description = "SaC testing api-gw deployment stage"   
  stage_name = "sac-apigw-deployment-stage-attachment"

  depends_on = [aws_api_gateway_method.sac_api_gateway_method]
}