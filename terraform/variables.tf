# Configure variables
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-3"
}

variable "instance_name" {
  description = "The AWS instance name"
  type        = string
  default     = "OpenVPN-Server"
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

variable "openvpn_dpi_bypass" {
  description = "DPI bypass for OpenVPN (default # - disabled)"
  type        = bool
  default     = true
}

variable "openvpn_port" {
  description = "Port for OpenVPN (default 1194)"
  type        = number
  default     = 1194
}

variable "openvpn_protocol" {
  description = "Protocol for OpenVPN (default udp)"
  type        = string
  default     = "udp"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "base_path" {
  description = "The path to the directory containing scripts"
  type        = string
  default     = ".."
}