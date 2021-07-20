variable "bucketname" {}

variable "DBenable" {}

variable "s3enable" {}

variable "tablename" {}
variable "environment" {}

output "dynamodb_arn" {
  value = "${element(aws_dynamodb_table.terraformLocks.*.arn)}"
}

output "dynamodb_id" {
  value = "${element(aws_dynamodb_table.terraformLocks.*.id)}"
}

output "dynamodb_name" {
  value = "${var.tablename}"
}

output "bucket_id" {
  value = "${element(aws_s3_bucket.default.*.id, 1)}"
}

resource "aws_dynamodb_table" "terraformLocks" {
  count          = "${var.DBenable}"
  name           = "${var.tablename}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name            = "${var.tablename}"
  }
}

resource "aws_s3_bucket" "default" {
  count  = "${var.s3enable}"
  bucket = "${var.bucketname}"
  acl    = "private"

  versioning {
    enabled = "true"
  }

  tags {
    Name            = "${var.bucketname}"
  }
}
