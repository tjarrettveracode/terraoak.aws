resource "aws_kinesis_stream" "kinesis_stream" {
  name                      = "kinesis_stream"
  shard_count               = 1
  enforce_consumer_deletion = false
  retention_period = 30
  kms_key_id                = aws_kms_key.foo_kinesis.arn # Must be configured
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kinesis_stream_consumer" "kinesis_stream_consumer" {
  # All options # Must be configured
  name       = "foo-kinesis-consumer"
  stream_arn = aws_kinesis_stream.kinesis_stream.arn
}
