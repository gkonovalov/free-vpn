# Generate a new key pair
resource "tls_private_key" "vpn_server_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an EC2 key pair using the public key
resource "aws_key_pair" "vpn_server_key" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.vpn_server_key.public_key_openssh
}