resource "aws_autoscaling_attachment" "springweb_extelb_asg_att" {
  count                  = "${var.springweb_enable}"
  autoscaling_group_name = "${aws_autoscaling_group.springweb.id}"
  elb                    = "${aws_elb.springweb-extelb.id}"
}

# TODO: add count flag in 2 AG to enable/disable use of /dev/sdc volume
resource "aws_launch_configuration" "springweb" {
  count                       = "${var.springweb_enable}"
  name_prefix                 = "${var.springweb_prefix}-asg-launch"
  image_id                    = "${var.amis}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.poc-springweb-web-sg.id}"]
  associate_public_ip_address = false
  user_data                   = "${data.template_file.userdata.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.rootvolumesize}"
    delete_on_termination = "true"
  }

  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "springweb" {
  count = "${var.springweb_enable}"
  name  = "${var.springweb_prefix}-asg"

  min_size                  = "${var.min_instances}"
  max_size                  = "${var.max_instances}"
  vpc_zone_identifier       = ["${split(",", var.public_subnet_ids)}"]
  launch_configuration      = "${aws_launch_configuration.springweb.name}"
  health_check_grace_period = 900                                        # should be grater than scale_in.estimated_instance_warmup because of instance boot
  health_check_type         = "EC2"

  tag = {
    key                 = "Name"
    value               = "${var.springweb_prefix}-AS-int"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = ["enabled_metrics"]
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  count                     = "${var.springweb_enable}"
  name                      = "${var.springweb_prefix}-asg-scaleout"
  autoscaling_group_name    = "${aws_autoscaling_group.springweb.name}"
  policy_type               = "StepScaling"
  adjustment_type           = "ChangeInCapacity"
  metric_aggregation_type   = "Average"
  estimated_instance_warmup = 900

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0.0
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  count                  = "${var.springweb_enable}"
  name                   = "${var.springweb_prefix}-asg-scalein"
  autoscaling_group_name = "${aws_autoscaling_group.springweb.name}"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 0.0
  }
}
