data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    hostname = "${var.springweb_prefix}-AS-int"
    resolvers = "poc.tech"
    role        = "springweb"
    environment = "${var.environment}"
    region      = "${var.region}"
    datacenter  = "${replace(var.region, "-", "")}"
  }
}
