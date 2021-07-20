variable "addspace" {}
variable "addvol" {}
variable "amis" {}
variable "availability_zones" {}
variable "environment" {}
variable "instance_type" {}
variable "key_name" {}
variable "min_instances" {}
variable "max_instances" {}

variable "pubkey" {}
variable "public_subnet_ids" {}
variable "region" {}
variable "required_azs" {}
variable "rootvolumesize" {
  default = "10"
}
variable "poccidrblocks" {
  type = "list"

  default = []
}

variable "vpc_cdir" {}
variable "vpc_id" {}
variable "springweb_enable" {}
variable "springweb_prefix" {}
variable "springweb_prj_prefix" {}
