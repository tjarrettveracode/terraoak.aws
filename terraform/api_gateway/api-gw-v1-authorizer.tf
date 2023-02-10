
resource "aws_api_gateway_authorizer" "api_gateway_auth_user_pool" {
  # All options # Must be configured
  name                             = "CognitoUserPoolAuthorizer"
  type                             = "COGNITO_USER_POOLS"
  rest_api_id                      = aws_api_gateway_rest_api.api_gateway_rest_api.id
  provider_arns                    = [aws_cognito_user_pool.api_gateway_cognito.arn]
  authorizer_result_ttl_in_seconds = 30 # Must be less than equal to 30
  identity_source                  = "method.request.header.Authorization"
}

resource "aws_api_gateway_authorizer" "api_gateway_auth_custom" {
  # All options # Must be configured
  name                             = "CustomAuthorizer"
  type                             = "TOKEN"
  rest_api_id                      = aws_api_gateway_rest_api.api_gateway_rest_api.id
  authorizer_result_ttl_in_seconds = 30 # Must be less than equal to 30
  authorizer_uri                   = aws_lambda_function.foo_apigw.invoke_arn
  identity_source                  = "method.request.header.Authorization" 
  # Applies when authorizer type is Custom
  # authorizer_credentials           = var.authorizer_credentials # Must be configured
}

resource "aws_api_gateway_request_validator" "api_gateway_auth_validator" {
  # All options # Must be configured
  name                        = "ApiGateway-RequestValidator"
  rest_api_id                 = aws_api_gateway_rest_api.api_gateway_rest_api.id
  validate_request_body       = true
  validate_request_parameters = true
}
