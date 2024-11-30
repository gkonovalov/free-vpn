# Free VPN

Free VPN - tool for simplifying VPN server setup and management on `AWS` using `Terraform`, `Ansible` and `AWS CLI`. It simplifies creating, listing, and destroying VPN servers, leveraging AWS Free Tier to minimize costs. Additionally, it supports both `WireGuard` and `OpenVPN` server variants, `multi-region` deployments and offers `DPI (Deep Packet Inspection) bypass` and includes `DNS leak` prevention to ensure reliable and secure VPN access in restrictive network environments.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installing Dependencies](#installing-dependencies)
- [How to Use the `vpn.py` Script](#how-to-use-the-vpnpy-script)
- [Cloning the Repository](#cloning-the-repository)
- [Additional Resources](#additional-resources)

## <a id="prerequisites">Prerequisites</a>

To utilize this tool effectively, you will need the following:

- **AWS Account**: An active AWS account with access to the [AWS Free Tier](https://github.com/gkonovalov/free-vpn/blob/main/docs/aws.md).
- **Python (v. 3.x or higher)**.
- **Terraform (v. 1.2 or higher)**.
- **Ansible (v. 2.17 or higher)**.
- **AWS CLI (v. 2.17 or higher)**.

## <a id="installing-dependencies">Installing Dependencies</a>

Follow these steps to set up the required dependencies for this tool:

1. **Install Python**:

   To install Python on macOS, use [Homebrew](https://brew.sh/). Open your terminal and run:

    ```bash
    brew install python
    ```

   For additional installation methods across different operating systems, refer to the [official Python installation guide](https://www.python.org/downloads/).

2. **Install Terraform**:

   To install Terraform on macOS, use Homebrew. Execute the following commands in your terminal:

    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

   For further details and installation instructions for other platforms, consult the [official Terraform installation guide](https://developer.hashicorp.com/terraform/install).

3. **Install Ansible**:

   Install Ansible on macOS using Homebrew by running:

    ```bash
    brew install ansible
    ```

   For comprehensive installation methods on various operating systems, check the [official Ansible installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

4. **Install AWS CLI**:

   To install AWS CLI on macOS, use Homebrew with the following command:

    ```bash
    brew install awscli
    ```

   For additional information and installation methods on different platforms, refer to the [official AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

   After installation, configure the AWS CLI with your [access keys](https://github.com/gkonovalov/free-vpn/blob/main/docs/aws.md#create-aws-and-access-keys). You will be prompted to enter your `Access Key ID`, `Secret Access Key`, default region name, and output format:

    ```bash
    aws configure
    ```

## <a id="how-to-use-the-vpnpy-script">How to Use the `vpn.py` Script</a>

To create a new VPN server, run the Python script:

1. **Run the Python Script**:

    ```bash
    python vpn.py
    ```

    When you run `vpn.py`, you will be prompted to choose one of the following actions:

    - `create`: Set up a new VPN server.
    - `destroy`: Remove an existing VPN server.
    - `list`: View all active VPN servers.


2. **Choose Parameters**:

    To customize your VPN server setup, you can modify the following configuration parameters in the `vpn.py` script:

    - `aws_region`: Specify the AWS region where the VPN server will be deployed (e.g., `us-east-1`).
    - `instance_name`: Set a unique name for your VPN instance (e.g., `vpn-server`).
    - `instance_type`: Choose the type of AWS instance (e.g., `t3.micro`).
    - `vpn_server_type`: Specify type of VPN Server (e.g., `wireguard`, or `openvpn`).
    - `vpn_dpi_bypass`: Configure DPI bypass (only for OpenVPN) by setting this parameter to `yes` for enabled or `no` for disabled.
    - `vpn_port`: Set the port number for VPN (e.g. `1194`).
    - `vpn_protocol`: Specify the protocol used by VPN (e.g., `udp` or `tcp`).


3. **Obtain VPN client configuration**:

    After running the `vpn.py` script, the following VPN client configuration and certificates will be available in the local region-specific directory (e.g., `servers/us-east-1/`):

    - `wireguard_client.conf`: Configuration file with keys for WireGuard.
    - `openvpn_client.ovpn`:  Configuration file with keys for OpenVPN.


4. **Download VPN client**:

    After obtaining your configuration file, you need to download the VPN client software. You can find instructions for installing the VPN client on [macOS and iOS here](https://github.com/gkonovalov/free-vpn/blob/main/docs/client.md).


## <a id="cloning-the-repository">Cloning the Repository</a>

To clone the repository, follow these steps:

1. Open a terminal or command prompt.
2. Navigate to the directory where you want to clone the repository.
3. Run the following command:

    ```bash
    git clone https://github.com/gkonovalov/free-vpn.git
    cd free-vpn
    ```

## <a id="additional-resources">Additional Resources</a>
- [Setting Up AWS Free Tier](https://github.com/gkonovalov/free-vpn/blob/main/docs/aws.md)
- [Install VPN Client (macOS & iOS)](https://github.com/gkonovalov/free-vpn/blob/main/docs/client.md)

------------
Georgiy Konovalov 2024 (c) [MIT License](https://opensource.org/licenses/MIT)