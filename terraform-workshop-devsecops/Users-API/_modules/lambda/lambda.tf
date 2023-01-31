resource "aws_lambda_function" "UsersGet" {
  function_name = "Users-Get"


  s3_bucket = "terraform-webinar-demo-files"
  s3_key    = "user-store-get.zip"

  runtime = "python3.9"
  handler = "user-get.lambda_handler"

  source_code_hash = var.source_code_hash_get
  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "UsersSet" {
  function_name = "Users-Set"

  s3_bucket = "terraform-webinar-demo-files"
  s3_key =  "user-store-set.zip"


  runtime = "python3.9"
  handler = "user-set.lambda_handler"

  source_code_hash = var.source_code_hash_set

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "lambdaUsersApi" {
  name = "/aws/lambda/LambdaUsersApi"

  retention_in_days = 30
}



resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "DynamoDbReadWrite" {
  name = "oak9DynamoDbReadWrite"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:BatchGetItem",
          "dynamodb:PutItem",
          "dynamodb:DescribeTable",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:ListTagsOfResource",
          "dynamodb:UpdateItem",
          "dynamodb:UpdateTable",
          "dynamodb:UpdateTimeToLive",
          "dynamodb:ListTables",
          "dynamodb:ListStreams",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetRecords",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"          
        ],
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_dyanmodb" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.DynamoDbReadWrite.arn
}
