resource "aws_api_gateway_resource" "sac_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id   # Required
  parent_id   = aws_api_gateway_rest_api.sac_api_gateway_rest_api.root_resource_id   # Required
  path_part   = "{proxy+}"   # Required
}

resource "aws_api_gateway_integration" "sac_api_gateway_integration" {
  rest_api_id = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id  # Required
  resource_id = aws_api_gateway_resource.sac_api_gateway.id   # Required
  http_method = aws_api_gateway_method.sac_api_gateway_method.http_method   # Required
  type = "MOCK"   # Required
  depends_on = [aws_api_gateway_method.sac_api_gateway_method]  # Required
}