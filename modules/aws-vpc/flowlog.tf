resource "aws_flow_log" "flowlog" {
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
  iam_role_arn   = "${var.flowlog_role}"
  vpc_id         = "${aws_vpc.mod.id}"
  traffic_type   = "${var.traffic_type}"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "vpc_flowlog_group"
  retention_in_days = "7"
}

resource "aws_cloudwatch_log_group" "S3_log_group" {
  name = "/aws/kinesisfirehose/vpc_flowlog_stream"
}
