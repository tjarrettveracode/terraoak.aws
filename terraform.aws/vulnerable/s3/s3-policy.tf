# SaC Testing - Severity: Critical - Set aws_s3_bucket_policy to undefined
resource "aws_s3_bucket_policy" "s3_bucket_policy_sac" {
  bucket = aws_s3_bucket.s3_bucket_sac.id
  policy = <<EOF
{
"Version": "2012-10-17",
"Id": "PutObjPolicy",
"Statement": [{
  "Sid": "DenyObjectsThatAreNotSSEKMS",
  "Principal": "*",
  "Effect": "Allow",
  "Action": "*",
  "Resource": "${aws_s3_bucket.s3_bucket_sac.arn}/*",
  "Condition": {
    "Null": {
      "s3:x-amz-server-side-encryption-aws-kms-key-id": "true"
    }
  }
}]
}
EOF
}