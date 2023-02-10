resource "aws_api_gateway_api_key" "api_gateway_key" {
  # All options # Must be configured
  name        = "ApiGateway-key"
  description = "API key for foo Gateway"
  enabled     = true
  value       = var.api_key

  # Must be present
  tags = {
    Environment = "production"
    Application = "foo"
  }
}

resource "aws_api_gateway_usage_plan_key" "api_gateway_usage_plan_key" {
  # All options # Must be configured
  key_id        = aws_api_gateway_api_key.api_gateway_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_gateway_usage_plan_key.id
}

resource "aws_api_gateway_rest_api_policy" "api_gateway_rest_api_policy" {
  # All options # Must be configured
  rest_api_id = aws_api_gateway_rest_api.foo.id

  policy= ""
} 

resource "aws_api_gateway_client_certificate" "api_gateway_client_certificate" {
  description = "My foo client certificate"
}

 resource "aws_api_gateway_domain_name" "example" {
   # All options # Must be configured
   domain_name = "foo.example.com"
   certificate_name        = "example-api"
   certificate_body        = file("${path.module}/example.com/example.crt")
   certificate_chain       = file("${path.module}/example.com/ca.crt")
   certificate_private_key = file("${path.module}/example.com/example.key")

   # Conflicts with certificate name, certificate body, certificate chain, certificate private_key 
   certificate_arn         = aws_acm_certificate.foo.arn # Used when endpoint_configuration typs is Edge
   # Conflicts with certificate arn, certificate name, certificate body, certificate chain, certificate private_key 
   regional_certificate_arn = aws_acm_certificate.foo.arn # Used when endpoint_configuration typs is Regional

   security_policy = "TLS_1_0"
   mutual_tls_authentication {
     truststore_uri     = "s3://bucket-name/key-name"
     truststore_version = "1"
   }

   endpoint_configuration {
     types = ["REGIONAL"]
   }
}
