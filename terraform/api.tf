resource "aws_api_gateway_rest_api" "sftp_auth_api" {
  name = "sftp_auth_api"
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
}
