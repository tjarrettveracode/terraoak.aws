resource "aws_api_gateway_rest_api" "user_webinar" {
  name                         = var.name
  description                  = var.description
  binary_media_types           = ["UTF-8-encoded", "application/octet", "image/jpeg"]
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_deployment" "webinar" {
  rest_api_id = aws_api_gateway_rest_api.user_webinar.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.webinar-proxy.id,
      aws_api_gateway_method.get.id,
      aws_api_gateway_integration.integration-get.id, 
      aws_api_gateway_method.set.id,
      aws_api_gateway_integration.integration-get.id
      ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "webinar" {
  deployment_id = aws_api_gateway_deployment.webinar.id
  rest_api_id   = aws_api_gateway_rest_api.user_webinar.id
  stage_name    = "webinar"
}

resource "aws_api_gateway_resource" "webinar-proxy" {
  rest_api_id = aws_api_gateway_rest_api.user_webinar.id
  parent_id   = aws_api_gateway_rest_api.user_webinar.root_resource_id
  path_part   = "{proxy+}"
}


resource "aws_api_gateway_method" "get" {
  rest_api_id   = "${aws_api_gateway_rest_api.user_webinar.id}"
  resource_id   = "${aws_api_gateway_resource.webinar-proxy.id}"
  http_method   = "GET"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.webinar-get.id
  request_parameters = {
    "method.request.querystring.id" = true
  }
}

resource "aws_api_gateway_request_validator" "webinar-get" {
  name                        = "webinar-get"
  rest_api_id                 = aws_api_gateway_rest_api.user_webinar.id
  validate_request_parameters = true
}

resource "aws_api_gateway_integration" "integration-get" {
  rest_api_id = aws_api_gateway_rest_api.user_webinar.id
  resource_id = aws_api_gateway_resource.webinar-proxy.id
  http_method = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  timeout_milliseconds   = 12000
  uri           = var.lambda_arn_get_user
}

resource "aws_api_gateway_method" "set" {
  rest_api_id   = "${aws_api_gateway_rest_api.user_webinar.id}"
  resource_id   = "${aws_api_gateway_resource.webinar-proxy.id}"
  http_method   = "POST"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.webinar-set.id
  request_parameters = {
    "method.request.querystring.id" = true, 
    "method.request.querystring.name" = true, 
    "method.request.querystring.orgid" = true, 
    "method.request.querystring.plan" = true, 
    "method.request.querystring.orgname" = true, 
    "method.request.querystring.creationdate" = true
  }
}

resource "aws_api_gateway_request_validator" "webinar-set" {
  name                        = "webinar-set"
  rest_api_id                 = aws_api_gateway_rest_api.user_webinar.id
  validate_request_parameters = true
}

resource "aws_api_gateway_integration" "integration-set" {
  rest_api_id = aws_api_gateway_rest_api.user_webinar.id
  resource_id = aws_api_gateway_resource.webinar-proxy.id
  http_method = aws_api_gateway_method.set.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  timeout_milliseconds   = 12000
  uri           = var.lambda_arn_set_user
}

resource "aws_lambda_permission" "allow_api-gateway_get" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_func_get_user_name
  principal     = "apigateway.amazonaws.com"
  source_arn    =  "${aws_api_gateway_rest_api.user_webinar.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api-gateway_set" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_func_set_user_name
  principal     = "apigateway.amazonaws.com" 
  source_arn    = "${aws_api_gateway_rest_api.user_webinar.execution_arn}/*/*"
}