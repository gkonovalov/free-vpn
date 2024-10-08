# Obtaining public IP
output "server_ip" {
  description = "Public IP of the OpenVPN EC2 instance"
  value       = aws_eip.external_ip.public_ip
}