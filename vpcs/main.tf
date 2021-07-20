## Creates A VPC Per Region ##

module "aws-vpc" {
  source               = "../../../../modules/aws-vpc"
  cidr                 = "${lookup(var.vpc_cidrs, "${var.region}-${var.environment}")}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  region               = "${var.region}"
  public_ranges        = "${lookup(var.public_ranges, "${var.region}-${var.environment}")}"
  private_ranges       = "${lookup(var.private_ranges, "${var.region}-${var.environment}")}"
  azs                  = "${lookup(var.azs, "${var.region}-${var.environment}")}"
  sid                  = "${var.sid}"
  environment          = "${var.environment}"
  acc_number           = "${var.acc_number}"
  traffic_type          = "${var.traffic_type}"
  flowlog_role          = "${lookup(var.flowlog_role, "${var.environment}")}"
}

output "vpc-id" {
    value = "${module.aws-vpc.vpc-id}"
}

output "public-subnets" {
    value = "${module.aws-vpc.public-subnets}"
}

output "private-subnets" {
    value = "${module.aws-vpc.private-subnets}"
}

output "availability-zones" {
    value = "${module.aws-vpc.availability-zones}"
}

output "vpc_cidr" {
    value = "${lookup(var.vpc_cidrs, "${var.region}-${var.environment}")}"
}

output "nat_eips" {
    value = "${module.aws-vpc.nat_eips}"
}
