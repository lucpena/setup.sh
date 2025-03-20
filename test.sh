#!/bin/bash

# Add repository
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_23.10/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list

# Import GPG key
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_23.10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null

# Update package lists
sudo apt update

# Install OneDriver
sudo apt install -y onedriver

echo "OneDriver installation complete."
