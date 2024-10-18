locals {
  state                   = "${path.root}/../servers/${var.aws_region}"
  state_file              = "${local.state}/config.json"
  ssh_key_path            = "${local.state}/${var.ssh_key_name}"
}