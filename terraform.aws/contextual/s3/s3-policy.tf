resource "aws_s3_bucket_policy" "s3_bucket_policy_sac" {
  bucket = aws_s3_bucket.s3_bucket_sac.id
  policy = <<EOF
{
"Version": "2012-10-17",
"Id": "PutObjPolicy",
"Statement": [{
  "Sid": "DenyObjectsThatAreNotSSEKMS",
  "Principal": {"AWS" : "${aws_iam_role.s3_bucket_role.arn}"},
  "Effect": "Deny",
  "Action": "s3:PutObject",
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

resource "aws_iam_role" "s3_bucket_role" {
  name = "s3-bucket-role-sac"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}