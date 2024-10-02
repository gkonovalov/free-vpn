# Configure instance public IP
resource "aws_eip" "external_ip" {
  vpc = true
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_association" {
  instance_id   = aws_instance.openvpn_server.id
  allocation_id = aws_eip.external_ip.id
}