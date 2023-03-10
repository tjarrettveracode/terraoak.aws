resource "aws_s3_bucket_public_access_block" "s3_public_access_block_sac" {
  bucket = aws_s3_bucket.s3_bucket_sac.id
  
  # DEMO - severity change based on data sensitivity Moderate -> High
  ignore_public_acls      = false
  # DEMO - severity change based on data sensitivity High -> Critical
  block_public_acls       = false
  block_public_policy     = true
  restrict_public_buckets = true
}