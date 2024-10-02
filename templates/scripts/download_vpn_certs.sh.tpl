#!/bin/bash

# SSH into the server
echo 'Downloading OpenVPN client certificates...'
sudo scp -P ${port} -i ../keys/${key_name} ${username}@${public_ip}:/home/${username}/client/* ../openvpn/