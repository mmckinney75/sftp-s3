resource "aws_s3_bucket" "sftp_bucket" {
  bucket = "mmckinney-sftp"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  force_destroy = true

  tags = {
    Name = "mmckinney-sftp"
  }
}

resource "aws_s3_bucket_policy" "sftp_bucket_policy" {
  bucket = "${aws_s3_bucket.sftp_bucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::905570331231:user/mmckinney75",
                  "arn:aws:iam::905570331231:root"
                ]
            },
            "Action": "s3:*",
            "Resource": [
              "${aws_s3_bucket.sftp_bucket.arn}",
              "${aws_s3_bucket.sftp_bucket.arn}/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "partner1_bucket" {
  bucket = "mmckinney-partner1"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  force_destroy = true

  tags = {
    Name = "mmckinney-partner1"
  }
}

resource "aws_s3_bucket_policy" "partner1_bucket_policy" {
  bucket = "${aws_s3_bucket.partner1_bucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::905570331231:user/mmckinney75",
                  "arn:aws:iam::905570331231:root"
                ]
            },
            "Action": "s3:*",
            "Resource": [
              "${aws_s3_bucket.partner1_bucket.arn}",
              "${aws_s3_bucket.partner1_bucket.arn}/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "partner2_bucket" {
  bucket = "mmckinney-partner2"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  force_destroy = true

  tags = {
    Name = "mmckinney-partner2"
  }
}

resource "aws_s3_bucket_policy" "partner2_bucket_policy" {
  bucket = "${aws_s3_bucket.partner2_bucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::905570331231:user/mmckinney75",
                  "arn:aws:iam::905570331231:root"
                ]
            },
            "Action": "s3:*",
            "Resource": [
              "${aws_s3_bucket.partner2_bucket.arn}",
              "${aws_s3_bucket.partner2_bucket.arn}/*"
            ]
        }
    ]
}
POLICY
}
