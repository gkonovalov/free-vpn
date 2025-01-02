#!/bin/bash

# This script installs the necessary dependencies for the Free VPN tool
# It supports both macOS (using Homebrew) and Linux (using APT for Debian-based distributions)
# and checks if each dependency is already installed before installation.

echo "Starting installation of dependencies for Free VPN tool..."

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux system."

    # Update the package list
    echo "Updating package list..."
    sudo apt update

    # Check if Python is installed
    if command -v python3 &>/dev/null; then
        echo "Python is already installed: $(python3 --version)"
    else
        echo "Installing Python..."
        sudo apt install -y python3 python3-pip
    fi

    # Check if Terraform is installed
    if command -v terraform &>/dev/null; then
        echo "Terraform is already installed: $(terraform -v)"
    else
        echo "Installing Terraform CLI..."
        sudo apt install -y wget
        wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt install terraform
    fi

    # Check if AWS CLI is installed
    if command -v aws &>/dev/null; then
        echo "AWS CLI is already installed: $(aws --version)"
    else
        echo "Installing AWS CLI..."
        sudo apt install -y awscli
    fi

    # Check if Ansible is installed
    if command -v ansible &>/dev/null; then
        echo "Ansible is already installed: $(ansible --version)"
    else
        echo "Installing Ansible..."
        sudo apt install -y ansible
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS system."

    # Check for Homebrew and install if not installed
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi

    # Check if Python is installed
    if command -v python3 &>/dev/null; then
        echo "Python is already installed: $(python3 --version)"
    else
        echo "Installing Python..."
        brew install python
    fi

    # Check if Terraform is installed
    if command -v terraform &>/dev/null; then
        echo "Terraform is already installed: $(terraform -v)"
    else
        echo "Installing Terraform CLI..."
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
    fi

    # Check if AWS CLI is installed
    if command -v aws &>/dev/null; then
        echo "AWS CLI is already installed: $(aws --version)"
    else
        echo "Installing AWS CLI..."
        brew install awscli
    fi

    # Check if Ansible is installed
    if command -v ansible &>/dev/null; then
        echo "Ansible is already installed: $(ansible --version)"
    else
        echo "Installing Ansible..."
        brew install ansible
    fi
else
    echo "Unsupported operating system."
    exit 1
fi

echo "All dependencies installed successfully. You can now configure the AWS CLI."

# AWS CLI configuration reminder
echo "Run 'aws configure' to configure your AWS CLI with access keys."

# End of script
echo "Installation process completed!"