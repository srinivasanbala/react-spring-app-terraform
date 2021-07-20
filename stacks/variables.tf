
variable "cluster" {}
variable "springwebnodes" {}



variable "environment" {}
variable "account" {
  default = "dev"
}

variable "appid" {
  default = "poc"
}


variable "required_instances" {
  default = "1"
}
variable "springweb_enable" {}
variable "springweb_prefix" {}
variable "springweb_prj_prefix" {}
variable "region" {}

## Pearson IP Ranges ##
variable "poccidrblocks" {
   default = "0.0.0.0/0" # Change to your IP Range!
}

variable "key_name" {}

## Autoscaling? ##
variable "asg_min" {
  default = "1"
}

variable "asg_max" {
  default = "2"
}

variable "asg_desired" {
  default = "1"
}

variable "amis" {
  type = "map"
  default = {
    eu-west-1-dev = "ami-0ec23856b3bad62d3"
  }
}

variable "vpc_cidrs" {
  default = {
        vpc-0149f50e9cf825090 = "10.69.96.0/21"
        }
}

# Instance types are in variables.tfvars

### Instance types ###
variable "instance_types" {
  type = "map"
  default = {
    springweb      = "t3.micro",
  }
}

# Apache
variable "pubkeys" { type = "map" }
