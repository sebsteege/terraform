#!/bin/bash

# Update the system package list
echo "Updating package lists..."
sudo apt update -y

# Install Apache2
echo "Installing Apache2 web server..."
sudo apt install apache2 -y

# Check and allow Apache Full profile in UFW firewall (opens ports 80 and 443)
echo "Configuring firewall..."
sudo ufw app list
sudo ufw allow 'Apache Full'
sudo ufw enable <<EOF
y
EOF
sudo ufw status

# Verify Apache status
echo "Checking Apache service status..."
sudo systemctl status apache2

echo "Apache installation complete. You can verify by visiting your server's IP address in a web browser."
