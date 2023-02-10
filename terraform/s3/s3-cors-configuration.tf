
resource "aws_s3_bucket_cors_configuration" "s3_cors_config_sac" {
  bucket = aws_s3_bucket.s3_bucket_sac.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}