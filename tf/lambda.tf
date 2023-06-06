
// Create archives for AWS Lambda functions which will be used for Step Function

data "archive_file" "archive-step-1-lambda" {
  type        = "zip"
  output_path = "../step-1-lambda/archive.zip"
  source_file = "../step-1-lambda/index.js"
}

data "archive_file" "archive-step-2-lambda" {
  type        = "zip"
  output_path = "../step-2-lambda/archive.zip"
  source_file = "../step-2-lambda/index.js"
}

data "archive_file" "archive-step-3-red-lambda" {
  type        = "zip"
  output_path = "../step-3-red-processor/archive.zip"
  source_file = "../step-3-red-processor/index.js"
}

data "archive_file" "archive-step-3-blue-lambda" {
  type        = "zip"
  output_path = "../step-3-blue-processor/archive.zip"
  source_file = "../step-3-blue-processor/index.js"
}

data "archive_file" "archive-step-writer-lambda" {
  type        = "zip"
  output_path = "../step-writer-lambda/archive.zip"
  source_file = "../step-writer-lambda/index.js"
}

// Create log group

resource "aws_cloudwatch_log_group" "step_func_log_group" {
  name              = "step_func_log_group"
  retention_in_days = 7
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

// Setup policy for lambda logging

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

// Attach policy

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

// Create AWS Lambda functions

resource "aws_lambda_function" "step-1-lambda" {
  filename         = "../step-1-lambda/archive.zip"
  function_name    = "step-functions-sample-step-1"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.archive-step-1-lambda.output_base64sha256
}

resource "aws_lambda_function" "step-2-lambda" {
  filename         = "../step-2-lambda/archive.zip"
  function_name    = "step-functions-sample-step-2"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.archive-step-2-lambda.output_base64sha256
}

resource "aws_lambda_function" "step-3-red-lambda" {
  filename         = "../step-3-red-processor/archive.zip"
  function_name    = "step-functions-sample-step-3-red"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.archive-step-3-red-lambda.output_base64sha256
}

resource "aws_lambda_function" "step-3-blue-lambda" {
  filename         = "../step-3-blue-processor/archive.zip"
  function_name    = "step-functions-sample-step-3-blue"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.archive-step-3-blue-lambda.output_base64sha256
}

resource "aws_lambda_function" "step-writer-lambda" {
  filename         = "../step-writer-lambda/archive.zip"
  function_name    = "step-functions-sample-step-writer"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.archive-step-writer-lambda.output_base64sha256
}

