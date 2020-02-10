resource "aws_api_gateway_rest_api" "sftp_auth_api" {
  name = "sftpUserAuth"
  description = "RestAPI to perform authentication for TransferSFTP service"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

resource "aws_api_gateway_resource" "sftp_auth_api_path_1" {
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sftp_auth_api.root_resource_id}"
  path_part   = "servers"
}

resource "aws_api_gateway_resource" "sftp_auth_api_path_2" {
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  parent_id   = "${aws_api_gateway_resource.sftp_auth_api_path_1.id}"
  path_part   = "{serverId}"
}

resource "aws_api_gateway_resource" "sftp_auth_api_path_3" {
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  parent_id   = "${aws_api_gateway_resource.sftp_auth_api_path_2.id}"
  path_part   = "users"
}

resource "aws_api_gateway_resource" "sftp_auth_api_path_4" {
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  parent_id   = "${aws_api_gateway_resource.sftp_auth_api_path_3.id}"
  path_part   = "{username}"
}

resource "aws_api_gateway_resource" "sftp_auth_api_path_config" {
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  parent_id   = "${aws_api_gateway_resource.sftp_auth_api_path_4.id}"
  path_part   = "config"
}

resource "aws_api_gateway_method" "sftp_auth_api_config_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  resource_id   = "${aws_api_gateway_resource.sftp_auth_api_path_config.id}"
  http_method   = "GET"
  authorization = "AWS_IAM"
  request_parameters = {
    "method.request.header.Password" = false
  }
}

resource "aws_api_gateway_method_response" "sftp_auth_api_response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  resource_id = "${aws_api_gateway_resource.sftp_auth_api_path_config.id}"
  http_method = "${aws_api_gateway_method.sftp_auth_api_config_get.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "${aws_api_gateway_model.sftp_auth_api_response_model_config.name}"
    }
}

resource "aws_api_gateway_integration" "sftp_auth_api_lambda" {
   rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
   resource_id = "${aws_api_gateway_method.sftp_auth_api_config_get.resource_id}"
   http_method = "${aws_api_gateway_method.sftp_auth_api_config_get.http_method}"

   integration_http_method = "POST"
   type                    = "AWS"
   uri                     = "${aws_lambda_function.getUserAuthInfo_lambda.invoke_arn}"

   request_templates = {
     "application/json" = <<EOF
{
 "username": "$input.params('username')",
 "password": "$util.escapeJavaScript($input.params('Password')).replaceAll("\\'","'")",
 "serverId": "$input.params('serverId')"
}
EOF
}
}

resource "aws_api_gateway_model" "sftp_auth_api_response_model_config" {
   rest_api_id  = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
   name         = "getUserAuthInfoResponse"
   description  = "API response for getUserAuthInfo"
   content_type = "application/json"

   schema = <<EOF
{
  "$schema":"http://json-schema.org/draft-04/schema#",
  "title":"UserUserConfig",
  "type":"object",
  "properties":
  {
    "Role":
    {
      "type":"string"
    },
    "Policy":
    {
      "type":"string"
    },
    "HomeDirectory":
    {
      "type":"string"
    },
    "PublicKeys":
    {
      "type":"array",
      "items":
      {
        "type":"string"
      }
    }
  }
}
EOF
}

 resource "aws_api_gateway_integration_response" "sftp_auth_api_lambda_response" {
  depends_on = ["aws_api_gateway_integration.sftp_auth_api_lambda"]
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  resource_id = "${aws_api_gateway_method.sftp_auth_api_config_get.resource_id}"
  http_method = "${aws_api_gateway_method.sftp_auth_api_config_get.http_method}"
  status_code = "${aws_api_gateway_method_response.sftp_auth_api_response_200.status_code}"
}

resource "aws_api_gateway_deployment" "sftp_auth_api_lambda_deployment" {
  depends_on = ["aws_api_gateway_integration.sftp_auth_api_lambda"]
  rest_api_id = "${aws_api_gateway_rest_api.sftp_auth_api.id}"
  stage_name  = "prod"
}
