resource "aws_iam_role" "sftp_role" {
  name = "mckinney_sftp_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "transfer.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    name = "mckinney_sftp_role"
  }
}


resource "aws_iam_policy" "sftp_policy_root" {
  name        = "mmckinney_sftp_user_root"
  path        = "/"
  description = "Policy to allow root access to Transfer SFTP server"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfUserFolder",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.sftp_bucket.arn}"
            ]
        },
        {
            "Sid": "HomeDirObjectAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObjectVersion",
                "s3:DeleteObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "${aws_s3_bucket.sftp_bucket.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sftp_attach" {
  role       = "${aws_iam_role.sftp_role.name}"
  policy_arn = "${aws_iam_policy.sftp_policy_root.arn}"
}

resource "aws_iam_policy" "sftp_policy_user" {
  name        = "mmckinney_sftp_user"
  path        = "/"
  description = "Policy to allow user access to Transfer SFTP server"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "AllowListingOfUserFolder",
          "Action": [
              "s3:ListBucket"
          ],
          "Effect": "Allow",
          "Resource": [
              "arn:aws:s3:::$${Transfer:HomeBucket}"
          ],
          "Condition": {
              "StringLike": {
                  "s3:prefix": [
                      "$${Transfer:UserName}/*",
                      "$${Transfer:UserName}"
                  ]
              }
          }
      },
      {
          "Sid": "HomeDirObjectAccess",
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObjectVersion",
              "s3:DeleteObject",
              "s3:GetObjectVersion"
          ],
          "Resource": "arn:aws:s3:::$${Transfer:HomeDirectory}*"
      }
  ]
}
EOF
}


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
  name        = "lambda_sftp_s3_policy"
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
