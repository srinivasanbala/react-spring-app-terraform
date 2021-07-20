# modules/aws-vpc/aws-vpc.tf
resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name            = "poc-${replace(var.region, "-", "")}-vpc-${var.sid}"
  }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"

  tags {
    Name            = "ppc-${replace(var.region, "-", "")}-igw-${var.sid}"
  }
}

# for each in the list of availability zones, create the public subnet
# and private subnet for that list index,
# then create an EIP and attach a nat_gateway for each one.  and an aws route
# table should be created for each private subnet, and add the correct nat_gw

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${element(split(",", var.public_ranges), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index% length(var.azs))}"
  count             = "${length(compact(split(",", var.public_ranges)))}"

  tags {
    Name            = "${replace(element(split(",", var.azs), count.index), "-", "")}-${aws_vpc.mod.id}-public"
  }

  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${element(split(",", var.private_ranges), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index% length(var.azs))}"
  count             = "${length(compact(split(",", var.private_ranges)))}"

  tags {
    Name            = "${replace(element(split(",", var.azs), count.index), "-", "")}-${aws_vpc.mod.id}-private"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${replace(var.region, "-", "")}-db-subnet-group"
  subnet_ids = ["${aws_subnet.private.*.id}"]

  tags {
    Name            = "${replace(var.region, "-", "")}-db-subnet-group"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.mod.id}"

  tags {
    Name            = "${aws_vpc.mod.id}-public-sub-route-tb"
  }
}

# add a public gateway to each public route table
resource "aws_route" "public_gateway_route" {
  count                  = "${length(compact(split(",", var.private_ranges)))}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  depends_on             = ["aws_route_table.public"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mod.id}"
}

resource "aws_eip" "nat_eip" {
  count = "${length(split(",", var.public_ranges))}"
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = "${length(distinct(split(",", var.azs)))}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.mod"]
}

# for each of the private ranges, create a "private" route table.
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  count  = "${length(compact(split(",", var.private_ranges)))}"

  tags {
    Name            = "${replace(element(split(",", var.azs), count.index), "-", "")}-${aws_vpc.mod.id}-private-sub-route-tb"
  }
}

# add a nat gateway to each private subnet's route table
resource "aws_route" "private_nat_gateway_route" {
  count                  = "${length(compact(split(",", var.private_ranges)))}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
  nat_gateway_id         = "${element(aws_nat_gateway.nat_gw.*.id, count.index% length(var.azs))}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(compact(split(",", var.public_ranges)))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(compact(split(",", var.private_ranges)))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

## Outputs ##
output "vpc-id" {
  value = "${aws_vpc.mod.id}"
}

output "public-subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private-subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "availability-zones" {
  value = "${join(",", aws_subnet.public.*.availability_zone)}"
}

output "private-route-tbs" {
  value = "${join(",", aws_route_table.private.*.id)}"
}

output "nat_eips" {
  value = "${join(",", aws_eip.nat_eip.*.public_ip)}"
}
