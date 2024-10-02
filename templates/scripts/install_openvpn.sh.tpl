#!/bin/bash

# Update system locale
sudo localectl set-locale LANG=en_US.UTF-8

# Update system
sudo apt-get -y update
sudo apt-get -y upgrade --show-upgraded

# Configure Iptables-Persistent
sudo bash -c 'echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections'
sudo bash -c 'echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections'

# Install OpenVPN, Easy-RSA, iptables
sudo apt-get -y install openvpn udev easy-rsa dnsmasq iptables-persistent

# Copy Easy-RSA files
sudo mkdir openvpn-ca
sudo cp -r /usr/share/easy-rsa/* openvpn-ca/

# Initialize PKI, CA, and server certificates
sudo yes "yes" | ./openvpn-ca/easyrsa init-pki
sudo yes ""    | ./openvpn-ca/easyrsa build-ca nopass
sudo yes "yes" | ./openvpn-ca/easyrsa gen-req server nopass
sudo yes "yes" | ./openvpn-ca/easyrsa sign-req server server
sudo ./openvpn-ca/easyrsa gen-dh

# Generate client certificate
sudo yes ""    | ./openvpn-ca/easyrsa gen-req client1 nopass
sudo yes "yes" | ./openvpn-ca/easyrsa sign-req client client1

# Move certs/keys to OpenVPN directory
sudo cp ./pki/ca.crt ./pki/issued/server.crt ./pki/private/server.key ./pki/dh.pem /etc/openvpn/

# Create folder for certificates
sudo mkdir client

# Generate TLS-Auth key
if [ "${openvpn_dpi_bypass}" = "" ]; then
    sudo openvpn --genkey secret /etc/openvpn/ta.key
    sudo cp /etc/openvpn/ta.key client/
fi

# Move client certs/keys to Client directory
sudo cp pki/ca.crt pki/issued/client1.crt pki/private/client1.key client/
sudo chmod +r client/*

# Move server certs/keys to OpenVPN directory
sudo cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem /etc/openvpn/

# Remove configs-ca folder
sudo rm -rf openvpn-ca pki

# Move OpenVPN server config
sudo mv server.conf /etc/openvpn/

# Enable IP forwarding
sudo bash -c 'echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf'
sudo sudo sysctl -p

# Configure firewall
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -s 10.8.0.0/24 -j ACCEPT
sudo iptables -A FORWARD -j REJECT

#Save iptables rules
sudo sudo netfilter-persistent save

# Add DNS server configuration to DnsMasq config
sudo bash -c 'echo "listen-address=127.0.0.1,10.8.0.1" >> /etc/dnsmasq.conf'
sudo bash -c 'echo "interface=tun0" >> /etc/dnsmasq.conf'

# Restart OpenVPN and DnsMasq to apply changes
sudo systemctl restart openvpn@server
sudo systemctl restart dnsmasq