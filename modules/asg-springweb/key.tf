resource "aws_kms_key" "keysetup" {
  count               = "${var.springweb_enable}"
  description         = "POC Key Management ${var.region}"
  enable_key_rotation = true
}

resource "aws_kms_alias" "keysetup" {
  count         = "${var.springweb_enable}"
  name          = "alias/poc-${var.springweb_prefix}-kms01"
  target_key_id = "${aws_kms_key.keysetup.key_id}"
}
