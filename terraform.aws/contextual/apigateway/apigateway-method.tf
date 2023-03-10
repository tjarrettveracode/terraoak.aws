resource "aws_api_gateway_method" "sac_api_gateway_method" {
  rest_api_id = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.sac_api_gateway.id
  http_method = "GET"

  # DEMO - severity change based on business impact Moderate -> High
  authorization        = "NONE"
  authorizer_id        = aws_api_gateway_authorizer.sac_api_gateway_authorizer.id
}

resource "aws_api_gateway_authorizer" "sac_api_gateway_authorizer" {
  name                             = "CustomAuthorizer"
  rest_api_id                      = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id
  authorizer_uri                   = aws_lambda_function.sac_api_gateway_lambda_function.invoke_arn
   authorizer_credentials = aws_iam_role.sac_api_gateway_role.arn
}