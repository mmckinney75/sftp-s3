data "aws_route53_zone" "dns_zone" {
  name = "${var.zone_name}"
}

data "http" "my_ip" {
  url = "https://api.ipify.org?format=txt"
}
