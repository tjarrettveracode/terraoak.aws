resource "aws_s3_bucket" "s3_bucket_sac" {
  force_destroy       = false
  object_lock_enabled = false

  tags = {
    rule      = "all files"
  }
}