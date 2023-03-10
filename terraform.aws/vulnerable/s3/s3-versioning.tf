#SaC Testing - Severity: High - Set aws_bucket_versioning to undefined
resource "aws_s3_bucket_versioning" "s3_bucket_versioning_sac" {
  bucket = aws_s3_bucket.s3_bucket_sac.id
  versioning_configuration {
    status = "Disabled"
  }
}