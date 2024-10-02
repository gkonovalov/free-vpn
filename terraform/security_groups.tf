# Configure AWS security group
resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn_sg"
  description = "Security group for OpenVPN"

  ingress {
    from_port   = var.openvpn_port
    to_port     = var.openvpn_port
    protocol    = var.openvpn_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}