# Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.open_vpn_server_key.private_key_pem
  filename = local.ssh_key_path

  provisioner "local-exec" {
    command = "chmod 600 ${local.ssh_key_path}"
  }
}

# Update Config file
resource "local_file" "update_json" {
  filename = local.state_file
  content  = jsonencode(merge(jsondecode(file(local.state_file)), {
    server_ip = aws_eip.external_ip.public_ip
    ssh_port = var.ssh_port
    ssh_key_name = var.ssh_key_name
  }))
}