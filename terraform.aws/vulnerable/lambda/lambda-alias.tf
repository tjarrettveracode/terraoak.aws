resource "aws_lambda_alias" "test_lambda_alias" {
  name             = "alias-insecure-SaC"
  function_name    = aws_lambda_function.insecure_lambda_SAC.arn   
  function_version = "$LATEST"  
}