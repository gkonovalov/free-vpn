#Configure EC2 instance which will run OpenVPN
resource "aws_instance" "openvpn_server" {
  ami                    = data.aws_ami.debian.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.open_vpn_server_key.key_name
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  tags = {
    Name = var.instance_name
  }
}