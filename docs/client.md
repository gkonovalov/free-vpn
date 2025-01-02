## Install WireGuard Client (macOS & iOS)

### <a id="mac-os-installation-wireguard">macOS Installation</a>

WireGuard is a modern, high-performance VPN protocol that is simpler to set up and more efficient than OpenVPN.

1. **Download WireGuard**  
   Visit the [WireGuard website](https://www.wireguard.com/install/) and download the WireGuard client for macOS.

2. **Install WireGuard**  
   - Open the `.dmg` file from your Downloads folder.
   - Drag the WireGuard icon into the Applications folder.
   - Open WireGuard from your Applications folder.
   - You may need to enter your macOS administrator password to complete the installation.

3. **Configure WireGuard**:

   - After installation, open the WireGuard application.
   - Click **Import Tunnel(s) from File** and select your WireGuard configuration file (`.conf`).
   - Click **Activate** to start your VPN connection.

### <a id="ios-installation-wireguard">iOS Installation</a>

WireGuard provides a dedicated app for iOS that allows easy connection to your VPN.

1. **Download WireGuard**  
   Open the App Store on your iOS device and search for **WireGuard**. Alternatively, you can download it from this [link](https://apps.apple.com/us/app/wireguard/id1441195209).

2. **Install WireGuard**  
   Tap **Get** and follow the prompts to install the app on your iOS device.

3. **Import the VPN Configuration**:

   - Once WireGuard is installed, you can import your configuration file (`.conf`) by sending it to your iOS device via email, cloud storage, or AirDrop.
   - Tap the file and select **Copy to WireGuard**.
   - Follow the on-screen instructions to connect to your VPN.

---

## Install OpenVPN Client (macOS & iOS)

### <a id="mac-os-installation">macOS Installation</a>

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

### <a id="ios-installation">iOS Installation</a>

Tunnelblick is not available for iOS, but you can use the official OpenVPN Connect app to connect to your VPN.

1. **Download OpenVPN Connect**  
   Open the App Store on your iOS device and search for **OpenVPN Connect**. Alternatively, you can download it from this [link](https://apps.apple.com/us/app/openvpn-connect/id590379981).

2. **Install OpenVPN Connect**  
   Tap **Get** and follow the prompts to install the app on your iOS device.

3. **Import the VPN Configuration**:

   - Once OpenVPN Connect is installed, you can import your `.ovpn` file by sending it to your iOS device via email, cloud storage, or AirDrop.
   - Tap the file and select **Open in OpenVPN**.
   - Follow the on-screen prompts to connect to your VPN.

---
Georgiy Konovalov 2025 (c) [MIT License](https://opensource.org/licenses/MIT)