resource "aws_route53_record" "sftp_server_cname_rec" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "sftp"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_transfer_server.sftp_server.endpoint}"]
}
