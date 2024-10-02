#Configure EC2 instance which will run OpenVPN
resource "aws_instance" "openvpn_server" {
  ami                    = data.aws_ami.debian.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.open_vpn_server_key.key_name
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  provisioner "file" {
    content = templatefile(local.install_open_vpn_script_tpl, {
      openvpn_dpi_bypass = var.openvpn_dpi_bypass
    })

    destination = local.install_open_vpn_script_remote
  }

  provisioner "file" {
    content = templatefile(local.open_vpn_server_conf_tpl, {
      port               = var.openvpn_port
      protocol           = var.openvpn_protocol
      openvpn_dpi_bypass = var.openvpn_dpi_bypass
    })

    destination = local.open_vpn_server_conf_remote
  }

  provisioner "remote-exec" {
    inline = ["sh ${local.install_open_vpn_script_remote}"]
  }

  connection {
    type        = "ssh"
    user        = var.ssh_username
    host        = aws_instance.openvpn_server.public_ip
    private_key = file(local.client_ssh_key)
    timeout     = "10m"
  }

  tags = {
    Name = var.instance_name
  }
}