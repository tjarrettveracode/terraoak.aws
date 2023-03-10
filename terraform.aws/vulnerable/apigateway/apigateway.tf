resource "aws_api_gateway_resource" "sac_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id   
  parent_id   = aws_api_gateway_rest_api.sac_api_gateway_rest_api.root_resource_id   
  path_part   = "{proxy+}"   
}

resource "aws_api_gateway_integration" "sac_api_gateway_integration" {
  rest_api_id = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id  
  resource_id = aws_api_gateway_resource.sac_api_gateway.id   
  http_method = aws_api_gateway_method.sac_api_gateway_method.http_method   
  type = "MOCK"   
  depends_on = [aws_api_gateway_method.sac_api_gateway_method]  
}