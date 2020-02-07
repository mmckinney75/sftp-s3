################################################################################
# Role/Policy allowing Transfer SFTP service to access the S3 bucket where     #
# files are stored.  This role is applied to all SFTP users.  Access is        #
# restricted further by applying a ScopeDown Policy directly to the SFTP user  #
################################################################################

resource "aws_iam_role" "sftp_user_role" {
  name = "sftp_user"

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
    name = "sftp_user"
  }
}


resource "aws_iam_policy" "sftp_user_policy" {
  name        = "sftp_user"
  path        = "/"
  description = "Policy to allow access needed by the Transfer SFTP service"

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

resource "aws_iam_role_policy_attachment" "sftp_user_attach" {
  role       = "${aws_iam_role.sftp_user_role.name}"
  policy_arn = "${aws_iam_policy.sftp_user_policy.arn}"
}

################################################################################
# Scoped Down policy which restricts users access to specific paths in the     #
# bucket.  This policy is attached directly to the SFTP user configuration. It #
# can use four built-in user variables to make policy dynamic.                 #
################################################################################

resource "aws_iam_policy" "sftp_scopedown_policy" {
  name        = "sftp_user_scopedown"
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
      },
      {
          "Sid":"DenyDirCreation",
          "Effect":"Deny",
          "Action":[
              "s3:PutObject"
          ],
          "Resource": "arn:aws:s3:::$${Transfer:HomeDirectory}/*/"
      }
  ]
}
EOF
}
