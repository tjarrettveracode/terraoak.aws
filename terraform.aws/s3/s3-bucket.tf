resource "aws_s3_bucket" "s3_bucket_sac" {
  force_destroy       = false
  object_lock_enabled = false
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership_controls_sac" {
  bucket = aws_s3_bucket.s3_bucket_sac.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}