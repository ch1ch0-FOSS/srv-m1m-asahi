#!/bin/bash
# Checkpoint 02: User & SSH Setup, 2025-09-25
# Secure shell hardening and user creation

# Create users and set shells (adjust usernames as needed)
sudo useradd -m -s /usr/bin/zsh admin
sudo usermod -aG wheel admin
sudo useradd -m -s /bin/bash ch1ch0
sudo usermod -aG wheel ch1ch0

# Reload group data (optional)
newgrp wheel

# SSH key directory and permissions setup
sudo -u admin mkdir -p /home/admin/.ssh
sudo -u ch1ch0 mkdir -p /home/ch1ch0/.ssh

# Copy/paste pubkeys as needed to ~/.ssh/authorized_keys for each user
# Example for ch1ch0 (replace with actual key)
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvDSBqI7ED/V/E3... ch1ch0@duck.com" | sudo tee /home/ch1ch0/.ssh/authorized_keys

# Permission and SELinux restore
sudo chmod 700 /home/admin/.ssh /home/ch1ch0/.ssh
sudo chmod 600 /home/admin/.ssh/authorized_keys /home/ch1ch0/.ssh/authorized_keys
sudo restorecon -Rv /home/admin/.ssh /home/ch1ch0/.ssh

# SSH daemon hardening
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

sudo systemctl restart sshd

# Print SSH status for confirmation
sudo systemctl status sshd

echo "User and SSH setup completed at $(date)"
