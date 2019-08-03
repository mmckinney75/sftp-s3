resource "aws_cloudwatch_event_rule" "s3_put_event_rule" {
    name = "s3_put_event_rule"
    description = "Fires anytime a file is uploaded to S3 bucket"

    event_pattern = <<PATTERN
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "${aws_s3_bucket.sftp_bucket.id}"
      ]
    }
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "s3_put_event_target" {
    rule = "${aws_cloudwatch_event_rule.s3_put_event_rule.name}"
    arn = "${aws_lambda_function.triggeredMove_lambda.arn}"
}
