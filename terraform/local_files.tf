# Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.open_vpn_server_key.private_key_pem
  filename = local.client_ssh_key
}

# Save Refresh IP script
resource "local_file" "refresh_ip_script" {
  content = templatefile(local.refresh_ip_script_tpl, {
    workspace = terraform.workspace
  })

  filename = local.refresh_ip_script
}

# Save OpenVPN client config
resource "local_file" "vpn_client_config" {
  content = templatefile(local.open_vpn_client_conf_tpl, {
    public_ip = aws_eip.external_ip.public_ip
    port      = var.openvpn_port
    protocol  = var.openvpn_protocol
    openvpn_dpi_bypass = var.openvpn_dpi_bypass
  })

  filename = local.open_vpn_client_conf

  depends_on = [aws_instance.openvpn_server]
}

# Save SSH connection script
resource "local_file" "connect_ssh_script" {
  content = templatefile(local.connect_ssh_script_tpl, {
    public_ip = aws_eip.external_ip.public_ip
    port      = var.ssh_port
    username  = var.ssh_username
    key_name  = var.ssh_key_name
  })

  filename = local.connect_ssh_script

  depends_on = [aws_instance.openvpn_server]
}

# Save OpenVPN certificates download script
resource "local_file" "download_client_certs_script" {
  content = templatefile(local.download_vpn_certs_script_tpl, {
    public_ip = aws_eip.external_ip.public_ip
    port      = var.ssh_port
    username  = var.ssh_username
    key_name  = var.ssh_key_name
  })

  filename = local.download_vpn_certs_script

  depends_on = [aws_instance.openvpn_server]
}