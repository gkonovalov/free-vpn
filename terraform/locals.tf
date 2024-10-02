locals {
  # Paths for client and server scripts, SSH keys, and templates
  base_path                 = var.base_path
  workspace                 = terraform.workspace

  client_scripts            = "${local.base_path}/client/${local.workspace}"
  server_scripts_local      = "${local.base_path}/server/"
  server_scripts_remote     = "/home/${var.ssh_username}/"

  # SSH Key
  client_ssh_key            = "${local.client_scripts}/keys/${var.ssh_key_name}"

  # OpenVPN Server Configuration
  open_vpn_server_conf_tpl    = "${local.base_path}/templates/configs/server.conf.tpl"
  open_vpn_server_conf        = "${local.server_scripts_local}/server.conf"
  open_vpn_server_conf_remote = "${local.server_scripts_remote}/server.conf"

  # OpenVPN Client Configuration
  open_vpn_client_conf_tpl  = "${local.base_path}/templates/configs/client.ovpn.tpl"
  open_vpn_client_conf      = "${local.client_scripts}/openvpn/client.ovpn"

  # Install OpenVPN Script
  install_open_vpn_script_tpl     = "${local.base_path}/templates/scripts/install_openvpn.sh.tpl"
  install_open_vpn_script         = "${local.server_scripts_local}/install_openvpn.sh"
  install_open_vpn_script_remote  = "${local.server_scripts_remote}/install_openvpn.sh"

  # Refresh IP script
  refresh_ip_script_tpl     = "${local.base_path}/templates/scripts/refresh_ip.sh.tpl"
  refresh_ip_script         = "${local.client_scripts}/scripts/refresh_ip.sh"

  # Connect SSH script
  connect_ssh_script_tpl    = "${local.base_path}/templates/scripts/connect_ssh.sh.tpl"
  connect_ssh_script        = "${local.client_scripts}/scripts/connect_ssh.sh"

  # Download VPN certificates
  download_vpn_certs_script_tpl = "${local.base_path}/templates/scripts/download_vpn_certs.sh.tpl"
  download_vpn_certs_script     = "${local.client_scripts}/scripts/download_vpn_certs.sh"
}