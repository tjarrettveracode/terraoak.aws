resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_kinesis_stream.test_stream.arn
  function_name     = aws_lambda_function.insecure_lambda_SAC.arn   # Required
  starting_position = "LATEST"
}

resource "aws_kinesis_stream" "test_stream" {
  name             = "terraform-kinesis-test"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Environment = "test"
  }
}