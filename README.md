# Free VPN

Free VPN: A management tool for simplifying VPN server setup and management on `AWS` using `Terraform` and `AWS CLI`. It simplifies creating, listing, and destroying VPN servers, leveraging AWS Free Tier to minimize costs. Additionally, it supports `multi-region` deployments and offers `DPI (Deep Packet Inspection) bypass` to ensure reliable VPN access in restrictive network environments.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setting Up AWS Free Tier](#setting-up-aws-free-tier)
- [Installing Dependencies](#installing-dependencies)
- [How to Use the `vpn.py` Script](#how-to-use-the-vpnpy-script)
- [Useful Scripts](#useful-scripts)
- [Install OpenVPN Client (macOS & iOS)](#install-openvpn-client-macos-ios)
- [Cloning the Repository](#cloning-the-repository)
- [Additional Resources](#additional-resources)

## <a id="prerequisites">Prerequisites</a>

To utilize this tool effectively, you will need the following:

- **AWS Account**: An active AWS account with access to the [Free Tier](https://aws.amazon.com/free/).
- **Python 3.x**: [Download Python](https://www.python.org/downloads/).
- **Terraform CLI (v. 1.2.0 or higher)**: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- **AWS CLI**: [Install AWS CLI](https://aws.amazon.com/cli/).


## <a id="setting-up-aws-free-tier">Setting Up AWS Free Tier</a>

As a new AWS customer, you are automatically enrolled in the Free Tier, which includes 750 hours of t2.micro instance usage per month for the first 12 months.

1. **Create an AWS Account**:
    - Go to the [AWS sign-up page](https://aws.amazon.com/free/).
    - Enter your email address and choose a password.
    - Provide a phone number for verification.
    - Follow the prompts to complete your registration.
   
2. **Select an EC2 Plan**:
    - Choose the AWS Free Tier, which allows new AWS customers to use certain services free for 12 months.
    - Be aware of the limits (750 hours of t2.micro usage per month, 15 GB of outbound bandwidth, etc.).
    - After 12 months, you will be billed at standard rates if you exceed free tier usage.
   
3. **Get Your AWS Access Key**:
    - Log in to the AWS Console.
    - Navigate to **IAM (Identity and Access Management)**:
        - Click on **Services** > **IAM**.
    - Under **Users**, click **Add User**.
    - Enter a username (e.g., `vpnuser`), check the box for **Programmatic Access**, and click **Next**.
    - **Attach Existing Policies**: 
        - Select the policies that provide necessary permissions (e.g., `AmazonEC2FullAccess` for EC2 management).
    - Review and create the user, then download the CSV file containing your **AWS Access Key ID** and **Secret Access Key**.


## <a id="installing-dependencies">Installing Dependencies</a>

To set up the required dependencies for this tool, follow these steps:

1. **Install Python**:

   You can install Python using [Homebrew](https://brew.sh/) on macOS. Open your terminal and run:

    ```bash
    brew install python
    ```

2. **Install Terraform CLI**:

   You can install Terraform using [Homebrew](https://brew.sh/) on macOS. Open your terminal and run the following commands:

    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

3. **Install AWS CLI**:

   To install the AWS CLI on macOS, follow the [official AWS installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
   Alternatively, you can install it using Homebrew by running the following command in your terminal:

    ```bash
    brew install awscli
    ```

   Ensure you have configured the AWS CLI with your access keys. You will be prompted for your `Access Key ID`, `Secret Access Key`, default region name, and output format:

    ```bash
    aws configure
    ```

## <a id="how-to-use-the-vpnpy-script">How to Use the `vpn.py` Script</a>

To create a new VPN server, run the Python script:

1. **Run Python Script**:

    ```bash
    python vpn.py
    ```

    When you run the `vpn.py` script, you will be prompted to choose one of the following actions:

    - `create`: This option allows you to set up a new VPN server.
    - `destroy`: Select this option to remove an existing VPN server. 
    - `list`: This command displays all active VPN servers that are currently running under your account. 


2. **Choose Parameters**:

    To customize your VPN server setup, you can modify the following configuration parameters in the `vpn.py` script:

    - `aws_region`: Specify the AWS region where the VPN server will be deployed (e.g., `us-east-1`).
    - `instance_name`: Set a unique name for your VPN instance (e.g., `OpenVPN-Server`).
    - `instance_type`: Choose the type of AWS instance (e.g., `t2.micro`).
    - `ssh_username`: Define the username for SSH access to the instance (e.g., `admin`).
    - `ssh_key_name`: Provide the name of your SSH key pair for secure access (e.g., `open_vpn_server_key.pem`).
    - `openvpn_port`: Set the port number for OpenVPN (default is usually `1194`).
    - `openvpn_protocol`: Specify the protocol used by OpenVPN (e.g., `udp` or `tcp`).
    - `openvpn_dpi_bypass`: Configure DPI bypass for OpenVPN by setting this parameter to `yes` for enabled or `no` for disabled.


3. **Download Certificates**:

    To set up your OpenVPN client, navigate to the `client` folder and locate the region-specific directory (e.g., `client/us-east-1/`). Inside the `scripts` folder, run the `download_vpn_certs.sh` script to download the necessary certificates and keys for your VPN connection:

    ```bash
    bash client/us-east-1/scripts/download_vpn_certs.sh
    ```

    After running the script, the following OpenVPN client configuration and certificates will be available in the `openvpn` folder:

    - `ca.crt`: Certificate authority file.
    - `client.ovpn`: OpenVPN configuration file.
    - `client1.crt`: Client certificate file.
    - `client1.key`: Client private key file.
    - `ta.key`: TLS authentication key.

#### <a id="useful-scripts">Useful Scripts</a>

- `connect_ssh.sh`: Securely connect to your VPN server via SSH.
- `download_vpn_certs.sh`: Download required OpenVPN certificates and keys.
- `refresh_ip.sh`: Refresh your VPN server’s IP address.


## <a id="install-openvpn-client-macos-ios">Install OpenVPN Client (macOS & iOS)</a>

### macOS Installation

Tunnelblick is a free, open-source OpenVPN client for macOS that helps manage VPN connections.

1. **Download Tunnelblick**  
   Visit the [Tunnelblick website](https://tunnelblick.net/downloads.html) and download the latest stable version for macOS.

2. **Install Tunnelblick**  
   After the download completes, follow these steps to install:

   - Open the `.dmg` file from your Downloads folder.
   - Drag the Tunnelblick icon into the Applications folder.
   - Open Tunnelblick from your Applications folder.
   - You may be prompted to enter your macOS administrator password to complete the installation.

3. **Configure Tunnelblick**:

   - After installation, open Tunnelblick.
   - If you have a `.ovpn` configuration file for your VPN, drag it onto the Tunnelblick icon in the menu bar or go to **File** > **Import VPN Configuration**.
   - Click **Connect** to start your VPN connection.

### iOS Installation

Tunnelblick is not available for iOS, but you can use the official OpenVPN Connect app to connect to your VPN.

1. **Download OpenVPN Connect**  
   Open the App Store on your iOS device and search for **OpenVPN Connect**. Alternatively, you can download it from this [link](https://apps.apple.com/us/app/openvpn-connect/id590379981).

2. **Install OpenVPN Connect**  
   Tap **Get** and follow the prompts to install the app on your iOS device.

3. **Import the VPN Configuration**:

   - Once OpenVPN Connect is installed, you can import your `.ovpn` file by sending it to your iOS device via email, cloud storage, or AirDrop.
   - Tap the file and select **Open in OpenVPN**.
   - Follow the on-screen prompts to connect to your VPN.


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

For more information on using AWS services and VPN configurations, consider checking the following resources:
- [AWS Documentation](https://docs.aws.amazon.com/) - Official documentation covering all AWS services, best practices, and guides.
- [Terraform Documentation](https://www.terraform.io/docs/index.html) - Comprehensive resources and tutorials for using Terraform to manage infrastructure as code.
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) - A guide to installing and configuring the AWS Command Line Interface for managing AWS services from your terminal.


------------
Georgiy Konovalov 2024 (c) [MIT License](https://opensource.org/licenses/MIT)