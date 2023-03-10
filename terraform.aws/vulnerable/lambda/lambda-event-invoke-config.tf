resource "aws_lambda_function_event_invoke_config" "example" {
  function_name = aws_lambda_alias.test_lambda_alias.arn    

  destination_config {
    on_success {
      destination = aws_sns_topic.topic-sns.arn 
    }
  }
}