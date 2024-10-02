# Obtaining public IP
output "instance_public_ip" {
  description = "Public IP of the OpenVPN EC2 instance"
  value       = aws_eip.external_ip.public_ip
}