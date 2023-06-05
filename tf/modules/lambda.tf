
// Create archives for AWS Lambda functions which will be used for Step Function

data "archive_file" "archive-step-2-lambda" {
  type        = "zip"
  output_path = "../step-2-lambda/archive.zip"
  source_file = "../step-2-lambda/index.js"
}

data "archive_file" "archive-step-1-lambda" {
  type        = "zip"
  output_path = "../step-1-lambda/archive.zip"
  source_file = "../step-1-lambda/index.js"
}

// Create IAM role for AWS Lambda

resource "aws_iam_role" "iam_for_lambda" {
  name = "stepFunctionSampleLambdaIAM"

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

// Create AWS Lambda functions

resource "aws_lambda_function" "step-1-lambda" {
  filename      = "../step-1-lambda/archive.zip"
  function_name = "step-functions-sample-step-1"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs8.10"
}

resource "aws_lambda_function" "step-2-lambda" {
  filename      = "../step-2-lambda/archive.zip"
  function_name = "step-functions-sample-step-2"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs8.10"
}

