resource "aws_security_group" "allow_office" {
  name        = "allow_office"
  description = "Allow all inbound traffic from office"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["64.124.17.226/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
