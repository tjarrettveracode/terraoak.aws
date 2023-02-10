resource "aws_s3_bucket_acl" "s3_bucket_acl-sac" {
  bucket = aws_s3_bucket.s3_bucket_sac.id
  acl    = "public-read-write"
}