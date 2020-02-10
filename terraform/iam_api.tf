
################################################################################
#          Role/Policy allowing APIGateway to write logs to CloudWatch         #
################################################################################

resource "aws_iam_role" "apigateway_cloudwatchLogging_role" {
  name = "apigateway_cloudwatchLogging"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "apigateway_cloudwatchLogging_policy" {
  name        = "apigateway_cloudwatchLogging"
  role        = "${aws_iam_role.apigateway_cloudwatchLogging_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:GetLogEvents",
        "logs:FilterLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
