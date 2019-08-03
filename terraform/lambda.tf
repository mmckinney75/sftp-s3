resource "aws_lambda_function" "triggeredMove_lambda" {
  filename      = "../lambda/triggeredMove.zip"
  function_name = "triggeredMove"
  role          = "${aws_iam_role.lambda_sftp_s3_role.arn}"
  handler       = "lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("../lambda/triggeredMove.zip")}"

  runtime = "python3.6"
}

resource "aws_lambda_permission" "triggeredMove_lamdba_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.triggeredMove_lambda.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.s3_put_event_rule.arn}"
}
