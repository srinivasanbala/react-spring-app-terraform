###AWS PROVIDER###


## Get Data From VPC State File ##
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "poc-terraform-${var.account}"
        key = "vpcs/${var.region}.tfstate"
        region = "eu-west-1"
    }
}

data "terraform_remote_state" "core" {
    backend = "s3"
    config {
        bucket = "poc-terraform-${var.account}"
        key = "core/${var.region}.tfstate"
        region = "eu-west-1"
    }
}

#### springweb ASG ####
module "asg-springweb" {
  addspace = "200"
  addvol = "0"
  amis = "${lookup(var.amis, "${var.region}-${var.account}")}"
  availability_zones = "${data.terraform_remote_state.vpc.availability-zones}"
  environment = "${var.environment}"
  instance_type = "${lookup(var.instance_types, "springweb")}"
  public_subnet_ids = "${data.terraform_remote_state.vpc.public-subnets}"
  key_name = "${var.key_name}"
  max_instances = "${var.springwebnodes}"
  poccidrblocks = "${split(",", var.poccidrblocks)}"
  pubkey = "${lookup(var.pubkeys, "springweb")}"
  public_subnet_ids = "${data.terraform_remote_state.vpc.public-subnets}"
  region = "${var.region}"
  required_azs = "3"
  rootvolumesize = "20"
  springweb_enable = "${var.springweb_enable}"
  springweb_prefix = "${var.springweb_prefix}"
  min_instances = "${var.asg_min}"
  max_instances = "${var.asg_max}"
  springweb_prj_prefix = "${var.springweb_prj_prefix}"
  source = "../../../../modules/asg-springweb"
  vpc_cdir = "${data.terraform_remote_state.vpc.vpc_cidr}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc-id}"
}
