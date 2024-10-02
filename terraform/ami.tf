#Filter AMI EC2 for Debian-11 linux
data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]
}