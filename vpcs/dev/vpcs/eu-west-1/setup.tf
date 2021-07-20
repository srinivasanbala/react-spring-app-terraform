# We cannot use variables to setup the backend
# the s3 bucket, its policy and the dynamoDB tables are created in setup/
# you can query its datasource if need be.
terraform {
  required_version = "= 0.9.11"
  backend "s3" {
    bucket = "poc-terraform-dev"
    key    = "vpcs/eu-west-1.tfstate"
    region = "eu-west-1"
    lock_table = "terraformLocks"
  }
}

# Let's keep the provider declaration heer so it will raise an error if we don't create this file
provider "aws" {
  region = "eu-west-1"
}
