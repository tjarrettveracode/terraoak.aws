resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = "lambda_layer_name"  # Required
  compatible_runtimes = ["ruby2.6"]
  description = "test description for a test config"
  filename   = "my-deployment-package.zip"
}