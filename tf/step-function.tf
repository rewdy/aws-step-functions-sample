
# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunctionSampleStepFunctionExecutionIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "policy_invoke_lambda" {
  name = "stepFunctionSampleLambdaFunctionInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_invoke_lambda.arn
}


// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "sample-state-machine"
  role_arn = aws_iam_role.iam_for_sfn.arn

  definition = <<EOF
{
  "Comment": "Sample step function",
  "StartAt": "Step1State",
  "States": {
    "Step1State": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-1-lambda.arn}",
      "Next": "Step2State",
      "Comment": "Executes the first step in the state machine"
    },
    "Step2State": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-2-lambda.arn}",
      "Next": "DispatchTypeProcessor",
      "Comment": "Executes the second step in the state machine"
    },
    "DispatchTypeProcessor": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.type",
          "StringEquals": "Red",
          "Next": "Step3RedProcessor"
        },
        {
          "Variable": "$.type",
          "StringEquals": "Blue",
          "Next": "Step3BlueProcessor"
        }
      ],
      "Default": "Writer"
    },
    "Step3RedProcessor": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-3-red-lambda.arn}",
      "Next": "Writer",
      "Comment": "This (fake) processes 'Red' types"
    },
    "Step3BlueProcessor": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-3-blue-lambda.arn}",
      "Next": "Writer",
      "Comment": "This (fake) processes 'Blue' types"
    },
    "Writer": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-writer-lambda.arn}",
      "End": true,
      "Comment": "Final (fake) write step"
    }
  }
}
EOF

  depends_on = [aws_lambda_function.step-1-lambda, aws_lambda_function.step-2-lambda, aws_lambda_function.step-3-blue-lambda, aws_lambda_function.step-3-red-lambda, aws_lambda_function.step-writer-lambda]
}
