resource "aws_transfer_server" "sftp_server" {
  endpoint_type          = "PUBLIC"
  identity_provider_type = "API_GATEWAY"
  url = "${aws_api_gateway_deployment.sftp_auth_api_lambda_deployment.invoke_url}"
  invocation_role = "${aws_iam_role.transfer_sftpUserAuthAPI_role.arn}"
  logging_role = "${aws_iam_role.transfer_cloudwatchLogging_role.arn}"
  tags = {
    NAME = "mmckinney_sftp_transfer"
  }
}

resource "aws_vpc_endpoint" "sftp_server_vpce" {
  vpc_id       = "${var.vpc_id}"
  service_name = "com.amazonaws.us-east-1.transfer"

  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.allow_in_ssh_all.id}",
  ]

  private_dns_enabled = true
}

## Root User Config (rootid)

# resource "aws_transfer_user" "sftp_user_rootid" {
#   server_id = "${aws_transfer_server.sftp_server.id}"
#   user_name = "rootid"
#   role      = "${aws_iam_role.sftp_user_role.arn}"
#   home_directory = "/${aws_s3_bucket.sftp_bucket.id}"
# }
#
# resource "aws_transfer_ssh_key" "sftp_key_rootid" {
#   server_id = "${aws_transfer_server.sftp_server.id}"
#   user_name = "${aws_transfer_user.sftp_user_rootid.user_name}"
#   body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcUj1XA1VebYeOQ2gtN7ZLAH9H1JYGCx8fjABd2mWxSPnBEave68ljZAAD9jgaxnAX+voKDVgUJFlIvquwvhKKPvKj4H+rqqa0aCYASYyc8KiBBdhRC5QrHJg1ioiWqfqgKM2BfIuTRMzY7LiFj3pRdOVNGjmAC5cRQ8aM6nfUpdq0rr6escq2jOTwDWGJzPq1UdwhMJjtIMElE6t7hlmPLvy7fRQ2C0JF9PnECohlkEcID8GFo+mpw8XmfJLY3qN2FBaOFXUkTepiwmTwrIBqqFcsvkD+L2rjyc80BcjSOZWfcW+S4efkOltJuDZtuJ+BCO5/zGQowGddXX011byv9nn7BHlP1O6BKWBJDVkbivSDMVc4FqMrumgxNvIKyinVgodEv+lePyqiZ7gtOB2KAfGacBRqcb9lJDiAU07W0ognQY5X9KxoRb/97Zfo2UhURcF+9Bpoihb7e+fgnJTOu7fWDGJ2TGONs23CAcBDjHJ3a7+JRmaDNa8Hng1zfEnc0HHVrgmWrCmAvfmGFcH70L0tI3J03m4h7ynSeozNaj7yQfikEtJFFnEc0ZBV9qFCzAlkoJlGGYOiaNqiiwf2qmqYUisqUCbPcri0L0pPyLAd4cCb9ZHJzceGr6rN4YXic8x+LgZYfi3IqA99Fc8Cq7Bt2lBKOQsLCOnGUBCM9Q== mmckinney75@gmail.com"
# }
#
#
# ## Restricted User Config (partner1)
# resource "aws_transfer_user" "sftp_user_partner1" {
#   server_id = "${aws_transfer_server.sftp_server.id}"
#   user_name = "partner1"
#   role      = "${aws_iam_role.sftp_user_role.arn}"
#   home_directory = "/${aws_s3_bucket.sftp_bucket.id}/partner1"
#   policy    = "${aws_iam_policy.sftp_scopedown_policy.policy}"
# }
#
# resource "aws_transfer_ssh_key" "sftp_key_partner1" {
#   server_id = "${aws_transfer_server.sftp_server.id}"
#   user_name = "${aws_transfer_user.sftp_user_partner1.user_name}"
#   body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcUj1XA1VebYeOQ2gtN7ZLAH9H1JYGCx8fjABd2mWxSPnBEave68ljZAAD9jgaxnAX+voKDVgUJFlIvquwvhKKPvKj4H+rqqa0aCYASYyc8KiBBdhRC5QrHJg1ioiWqfqgKM2BfIuTRMzY7LiFj3pRdOVNGjmAC5cRQ8aM6nfUpdq0rr6escq2jOTwDWGJzPq1UdwhMJjtIMElE6t7hlmPLvy7fRQ2C0JF9PnECohlkEcID8GFo+mpw8XmfJLY3qN2FBaOFXUkTepiwmTwrIBqqFcsvkD+L2rjyc80BcjSOZWfcW+S4efkOltJuDZtuJ+BCO5/zGQowGddXX011byv9nn7BHlP1O6BKWBJDVkbivSDMVc4FqMrumgxNvIKyinVgodEv+lePyqiZ7gtOB2KAfGacBRqcb9lJDiAU07W0ognQY5X9KxoRb/97Zfo2UhURcF+9Bpoihb7e+fgnJTOu7fWDGJ2TGONs23CAcBDjHJ3a7+JRmaDNa8Hng1zfEnc0HHVrgmWrCmAvfmGFcH70L0tI3J03m4h7ynSeozNaj7yQfikEtJFFnEc0ZBV9qFCzAlkoJlGGYOiaNqiiwf2qmqYUisqUCbPcri0L0pPyLAd4cCb9ZHJzceGr6rN4YXic8x+LgZYfi3IqA99Fc8Cq7Bt2lBKOQsLCOnGUBCM9Q== mmckinney75@gmail.com"
# }
#
#
# ## Restricted User Config (partner2)
# resource "aws_transfer_user" "sftp_user_partner2" {
#   server_id = "${aws_transfer_server.sftp_server.id}"
#   user_name = "partner2"
#   role      = "${aws_iam_role.sftp_user_role.arn}"
#   home_directory = "/${aws_s3_bucket.sftp_bucket.id}/partner2"
#   policy    = "${aws_iam_policy.sftp_scopedown_policy.policy}"
# }
#
# resource "aws_transfer_ssh_key" "sftp_key_partner2" {
#   server_id = "${aws_transfer_server.sftp_server.id}"
#   user_name = "${aws_transfer_user.sftp_user_partner2.user_name}"
#   body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcUj1XA1VebYeOQ2gtN7ZLAH9H1JYGCx8fjABd2mWxSPnBEave68ljZAAD9jgaxnAX+voKDVgUJFlIvquwvhKKPvKj4H+rqqa0aCYASYyc8KiBBdhRC5QrHJg1ioiWqfqgKM2BfIuTRMzY7LiFj3pRdOVNGjmAC5cRQ8aM6nfUpdq0rr6escq2jOTwDWGJzPq1UdwhMJjtIMElE6t7hlmPLvy7fRQ2C0JF9PnECohlkEcID8GFo+mpw8XmfJLY3qN2FBaOFXUkTepiwmTwrIBqqFcsvkD+L2rjyc80BcjSOZWfcW+S4efkOltJuDZtuJ+BCO5/zGQowGddXX011byv9nn7BHlP1O6BKWBJDVkbivSDMVc4FqMrumgxNvIKyinVgodEv+lePyqiZ7gtOB2KAfGacBRqcb9lJDiAU07W0ognQY5X9KxoRb/97Zfo2UhURcF+9Bpoihb7e+fgnJTOu7fWDGJ2TGONs23CAcBDjHJ3a7+JRmaDNa8Hng1zfEnc0HHVrgmWrCmAvfmGFcH70L0tI3J03m4h7ynSeozNaj7yQfikEtJFFnEc0ZBV9qFCzAlkoJlGGYOiaNqiiwf2qmqYUisqUCbPcri0L0pPyLAd4cCb9ZHJzceGr6rN4YXic8x+LgZYfi3IqA99Fc8Cq7Bt2lBKOQsLCOnGUBCM9Q== mmckinney75@gmail.com"
# }
