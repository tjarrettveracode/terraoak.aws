resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  # All options # Must be configured
  rest_api_id       = aws_api_gateway_rest_api.api_gateway_rest_api.id
  description       = "Foo api-gw deployment"
  stage_description = "Foo api-gw deployment stage"

  # Conflicts with resource type stage
  # stage_name = "Foo"
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_gateway_resource.id,
      aws_api_gateway_method.api_gateway_method.id,
      aws_api_gateway_integration.api_gateway_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  variables = {
    "version" = "02"
  }

  depends_on = [
    aws_api_gateway_integration.api_gateway_integration,
    aws_api_gateway_integration_response.api_gateway_integration_response,
    aws_api_gateway_method_response.api_gateway_method_response,
    aws_api_gateway_integration.api_gateway_integration
  ]
}

resource "aws_api_gateway_stage" "api_gateway_stage" {
  # All options # Must be configured
  deployment_id         = aws_api_gateway_deployment.api_gateway_stage.id
  description           = "Deployment stage for foos testing"
  rest_api_id           = aws_api_gateway_rest_api.api_gateway_rest_api.id
  stage_name            = "foo"
  cache_cluster_enabled = true
  cache_cluster_size    = 237
  xray_tracing_enabled  = false
  client_certificate_id = aws_api_gateway_client_certificate.api_gateway_client_certificate.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_cloudwatch.arn
    format          = <<EOF
  { 
  "requestId":"$context.requestId", \
  "ip": "$context.identity.sourceIp", \
  "caller":"$context.identity.caller", \
  "user":"$context.identity.user", \
  "requestTime":"$context.requestTime", \
  "httpMethod":"$context.httpMethod", \
  "resourcePath":"$context.resourcePath", \
  "status":"$context.status", \
  "protocol":"$context.protocol", \
  "responseLength":"$context.responseLength" \
}
EOF
  }
  variables = {
    "version" = "02"
  }

  tags = {
    Environment = "production"
    Application = "foo"
  }

  depends_on = [
    aws_api_gateway_account.api_gateway_account
  ]
}

resource "aws_api_gateway_model" "api_gateway_model" {
  rest_api_id  = aws_api_gateway_rest_api.api_gateway_rest_api.id
  name         = "foo"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "type": "object"
}
EOF
}
