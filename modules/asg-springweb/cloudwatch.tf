resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  count               = "${var.springweb_enable}"
  alarm_name          = "${var.springweb_prefix}-asg-highcpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "40"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.springweb.name}"
  }

  alarm_description = "This metric monitor ec2 high cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  count               = "${var.springweb_enable}"
  alarm_name          = "${var.springweb_prefix}-asg-lowcpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.springweb.name}"
  }

  alarm_description = "This metric monitor ec2 low cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_in.arn}"]
}
