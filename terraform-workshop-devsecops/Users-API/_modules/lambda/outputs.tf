output "function_name_get" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.UsersGet.function_name
}

output "function_name_set" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.UsersSet.function_name
}

output "lambda_arn_UsersGet" {
  value = aws_lambda_function.UsersGet.invoke_arn
} 

output "lambda_arn_UsersSet" {
  value = aws_lambda_function.UsersSet.invoke_arn
} 