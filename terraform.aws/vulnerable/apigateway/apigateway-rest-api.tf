resource "aws_api_gateway_rest_api" "sac_api_gateway_rest_api" {
  name = "sac-testing-apigw-rest-api"   

  endpoint_configuration {
    types = ["EDGE"]
  }
}
