#!/bin/bash

# SSH into the server
echo 'Connecting to OpenVPN server...'
sudo ssh ${username}@${public_ip} -p ${port} -i ../keys/${key_name}