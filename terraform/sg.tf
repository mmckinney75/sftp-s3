

resource "aws_security_group" "allow_in_ssh_all" {
  name        = "allow_in_ssh_all"
  description = "Allow inbound SSH traffic only"
  vpc_id      = "${var.vpc_id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [
        "0.0.0.0/0",
      ]
  }
}
