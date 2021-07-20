provider "aws" {
  region = "${var.region}"
}

module "bootstrap" {
  source      = "../../../../modules/terraform-bootstrap"
  bucketname  = "poc-terraform-${var.account}"
  DBenable    = "${var.DBenable}"
  s3enable    = "${var.s3enable}"
  environment = "${var.account}"
  tablename   = "terraformLocks"
}

output "dynamodb_arn" {
  value = "${module.bootstrap.dynamodb_arn}"
}

output "dynamodb_id" {
  value = "${module.bootstrap.dynamodb_id}"
}

output "dynamodb_name" {
  value = "${module.bootstrap.dynamodb_name}"
}

output "bucket_id" {
  value = "${module.bootstrap.bucket_id}"
}
