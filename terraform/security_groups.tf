# Configure AWS security group
resource "aws_security_group" "vpn_sg" {
  name        = "vpn_sg"
  description = "Security group for VPN"

  ingress {
    from_port   = var.vpn_port
    to_port     = var.vpn_port
    protocol    = var.vpn_protocol
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