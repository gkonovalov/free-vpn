# Configure variables
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-3"
}

variable "instance_name" {
  description = "The AWS instance name"
  type        = string
  default     = "vpn_server"
}

variable "server_ip" {
  description = "Public IP of the EC2 instance"
  type        = string
  default     = "127.0.0.1"
}

variable "ssh_port" {
  description = "The SSH port"
  type        = number
  default     = 22
}

variable "ssh_username" {
  description = "The SSH username"
  type        = string
  default     = "admin"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "ssh_key.pem"
}

variable "vpn_dpi_bypass" {
  description = "DPI bypass for VPN (default # - disabled)"
  type        = bool
  default     = true
}

variable "vpn_port" {
  description = "Port for VPN (default 1194)"
  type        = number
  default     = 1194
}

variable "vpn_protocol" {
  description = "Protocol for VPN (default udp)"
  type        = string
  default     = "udp"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}