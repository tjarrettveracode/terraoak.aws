resource "aws_api_gateway_rest_api" "sac_api_gateway_rest_api" {
  name = "sac-testing-apigw-rest-api"   

  tags = {
    key = "value"
  }

  endpoint_configuration {
    types = ["EDGE"]
  }

  # DEMO - severity change based on data sensitivity Moderate -> Critical
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "execute-api:Invoke",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
}