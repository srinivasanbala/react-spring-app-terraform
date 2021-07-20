## Sets Up The springweb Boxes ##

resource "aws_security_group" "poc-springweb-web-sg" {
  count       = "${var.springweb_enable}"
  name        = "${var.springweb_prefix}-sg"
  description = "${var.springweb_prefix}-sg"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.poc-springweb-elb-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name            = "${var.springweb_prefix}-sg"
  }
}

resource "aws_security_group" "poc-springweb-elb-sg" {
  count       = "${var.springweb_enable}"
  name        = "${var.springweb_prefix}-elb-sg"
  description = "${var.springweb_prefix}-elb-sg"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.poccidrblocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name            = "${var.springweb_prefix}-elb-sg"
  }
}
