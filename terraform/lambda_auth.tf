resource "aws_lambda_function" "getUserAuthInfo_lambda" {
  filename      = "../lambda/getUserAuthInfo.zip"
  function_name = "getUserAuthInfo"
  role          = "${aws_iam_role.lambda_getUserAuthInfo_role.arn}"
  handler       = "stub.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("../lambda/getUserAuthInfo.zip")}"

  runtime = "python3.7"

  environment {
    variables = {
      SecretsManagerRegion = "us-east-1"
    }
  }
}

resource "aws_lambda_permission" "getUserAuthInfo_lambda_apigateway" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.getUserAuthInfo_lambda.function_name}"
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.sftp_auth_api.execution_arn}/*"
}
