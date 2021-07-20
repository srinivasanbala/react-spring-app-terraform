
variable "environment" {
  default = "dev"
}

variable "sid" {
  default = "01"
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "enable_dns_support" {
  default = "true"
}
variable "region" {}

variable "vpc_cidrs" {
  type = "map"
  default = {
    eu-west-1-dev = "10.69.96.0/21"
    eu-central-1-dev = "10.70.32.0/21"
    eu-central-1-prod = "10.71.32.0/21"
    us-west-2-dev     = "10.68.96.0/21"
    us-east-1-dev = "NA"
    us-west-1-dev = "10.70.176.0/22"
    ap-se-1-dev = "10.71.58.0/23"
    ap-se-2-dev = "10.71.186.0/23"
    eu-west-1-prod = "10.69.240.0/22"
    us-east-1-prod = "10.68.240.0/22"
    us-west-2-prod = "10.67.240.0/22"
    us-west-1-prod = ""
    ap-se-1-prod = ""
    ap-se-2-prod = ""
  }
}

## You can add multiple subnets per region, and they will be mapped according to the azs mapping
## So if you want multiple subnets in the same az you must define them in the same order
## eg eu-west-1 = "10.69.96.0/25,10.69.96.128/25,10.69.97.0/25,10.69.97.0/25"
## eu-west-1 = "eu-west-1a,eu-west-1b,eu-west-1c"
## Would map ->
## 10.69.96.0/25 -> eu-west-1a
## 10.69.96.128/25 -> eu-west-1b
## 10.69.97.0/25 -> eu-west-1c
## 10.69.97.0/25 -> eu-west-1a
## Note the last one it loops back around

variable "public_ranges" {
  type = "map"
  default = {
    eu-west-1-dev = "10.69.96.0/25,10.69.96.128/25,10.69.97.0/25" #
    eu-central-1-dev =  "10.70.32.0/24,10.70.33.0/24"
    us-west-2-dev    =  "10.68.96.0/25,10.68.96.128/25,10.68.97.0/25"
    eu-central-1-prod = "10.71.32.0/24,10.71.33.0/24"
    us-east-1-dev = ""
    us-west-1-dev = ""
    ap-se-1-dev = ""
    ap-se-2-dev = ""
    eu-west-1-prod = "10.69.240.0/26,10.69.240.64/26,10.69.240.128/26"
    us-east-1-prod = "10.68.240.0/26,10.68.240.64/26,10.68.240.128/26"
    us-west-2-prod = "10.67.240.0/26,10.67.240.64/26,10.67.240.128/26"
    us-west-1-prod = ""
    ap-se-1-prod = ""
    ap-se-2-prod = ""
  }
}

variable "internal_ranges" {
  type = "map"
  default = {
    eu-west-1-dev = "10.69.98.0/24,10.69.99.0/24,10.69.100.0/24" #
    eu-central-1-dev =  "10.70.34.0/23,10.70.36.0/23"
    us-west-2-dev    =  "10.68.98.0/24,10.68.99.0/24,10.68.100.0/24"
    eu-central-1-prod = "10.71.34.0/23,10.71.36.0/23"
    us-east-1-dev = ""
    us-west-1-dev = ""
    ap-se-1-dev = ""
    ap-se-2-dev = ""
    eu-west-1-prod = "10.69.241.0/25,10.69.241.128/25,10.69.242.0/25"
    us-east-1-prod = "10.68.241.0/25,10.68.241.128/25,10.68.242.0/25"
    us-west-2-prod = "10.67.241.0/25,10.67.241.128/25,10.67.242.0/25"
    us-west-1-prod = ""
    ap-se-1-prod = ""
    ap-se-2-prod = ""
  }
}

variable "private_ranges" {
  type = "map"
  default = {
    eu-west-1-dev = "10.69.101.0/25,10.69.101.128/25,10.69.102.0/25" #
    eu-central-1-dev =  "10.70.38.0/24,10.70.39.0/24" #
    us-west-2-dev    =  "10.68.101.0/25,10.68.101.128/25,10.68.102.0/25"
    eu-central-1-prod = "10.71.38.0/24,10.71.39.0/24" #
    us-east-1-dev = ""
    us-west-1-dev = ""
    ap-se-1-dev = ""
    ap-se-2-dev = ""
    eu-west-1-prod = "10.69.243.0/26,10.69.243.64/26,10.69.243.128/26"
    us-east-1-prod = "10.68.243.0/26,10.68.243.64/26,10.68.243.128/26"
    us-west-2-prod = "10.67.243.0/26,10.67.243.64/26,10.67.243.128/26"
    us-west-1-prod = ""
    ap-se-1-prod = ""
    ap-se-2-prod = ""
  }
}

variable "azs" {
  type = "map"
  default = {
    eu-west-1-dev = "eu-west-1a,eu-west-1b,eu-west-1c"
    eu-central-1-dev =  "eu-central-1a,eu-central-1b"
    us-west-2-dev = "us-west-2a,us-west-2b,us-west-2c"
    eu-central-1-prod = "eu-central-1a,eu-central-1b"
    us-east-1-dev = ""
    us-west-1-dev = ""
    ap-se-1-dev = ""
    ap-se-2-dev = ""
    eu-west-1-prod = "eu-west-1a,eu-west-1b,eu-west-1c"
    us-east-1-prod = "us-east-1a,us-east-1b,us-east-1c"
    us-west-2-prod = "us-west-2a,us-west-2b,us-west-2c"
    us-west-1-prod = ""
    ap-se-1-prod = ""
    ap-se-2-prod = ""
  }
}

variable "flowlog_bucket_name" {}
variable "acc_number" {
  type = "map"

  default = {
    dev  = "328118002731"
    prod = "************"
  }
}
variable "s3-flowlog-encryption" {}
variable "traffic_type" {
  default = "ALL"
}

variable "flowlog_role" {
  type = "map"
  default = {
    dev  = "arn:aws:iam::328118002731:role/flowlogsRole"
    prod = ""
  }
}
