resource "aws_api_gateway_api_key" "sac_api_gateway_key" {
  name        = "sac-testing-apigw-key"
  description = "API key for SaC API Gateway"
  enabled     = true
}