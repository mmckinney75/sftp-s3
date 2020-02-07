
################################################################################
########## Role/Policy allowing Lambda to move files in S3 buckets #############
################################################################################

resource "aws_iam_role" "lambda_sftp_s3_role" {
  name = "lambda_sftp-s3"

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

resource "aws_iam_policy" "lambda_sftp_s3_policy" {
  name        = "lambda_sftp-s3"
  path        = "/"
  description = "Policy to allow Lambda to manage S3 buckets"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": "*"
    },
    {
          "Effect": "Allow",
          "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ],
          "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_sftp_s3_attach" {
  role       = "${aws_iam_role.lambda_sftp_s3_role.name}"
  policy_arn = "${aws_iam_policy.lambda_sftp_s3_policy.arn}"
}



################################################################################
# Role/Policy allowing Lambda to get users authentication information from     #
# SecretsManager.                                                              #
################################################################################

resource "aws_iam_role" "lambda_getUserAuthInfo_role" {
  name = "lambda_getUserAuthInfo"

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

resource "aws_iam_role_policy" "lambda_secretsManager_policy_inline" {
  name = "lambda_secretsManager"
  role = "${aws_iam_role.lambda_getUserAuthInfo_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:us-east-1:905570331231:secret:SFTP/*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_getUserAuthInfo_attach" {
  role       = "${aws_iam_role.lambda_getUserAuthInfo_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
