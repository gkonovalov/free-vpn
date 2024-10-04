locals {
  state                   = "${var.base_path}/state/${var.aws_region}"
  state_file              = "${local.state}/config.json"
  ssh_key_path            = "${local.state}/${var.ssh_key_name}"
}