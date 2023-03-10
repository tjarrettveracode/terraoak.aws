resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "*"   # Required
  function_name = aws_lambda_function.insecure_lambda_SAC.arn # Required
  principal     = "*"    # Required
}