resource "aws_lambda_layer_version_permission" "lambda_layer_permission" {
  layer_name     =  "arn:aws:lambda:us-east-2:709695003849:layer:lambda_layer_name"
  version_number = 4    # Required
  principal      = "*"   # Required
  action         = "*" # Required
  statement_id   = "dev-account"    # Required
}