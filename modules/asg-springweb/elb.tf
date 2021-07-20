resource "aws_elb" "springweb-extelb" {
  count = "${var.springweb_enable}"
  name  = "${var.springweb_prefix}-elb"

  # Set ELB accross all possible zones
  subnets = ["${split(",", var.public_subnet_ids)}"]

  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 8080
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 10
  }

  security_groups = ["${aws_security_group.poc-springweb-elb-sg.id}"]

  tags {
    Name            = "${var.springweb_prefix}-springweb-elb"
  }
}
