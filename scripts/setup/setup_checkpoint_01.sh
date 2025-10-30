#!/bin/bash
# Checkpoint 01: Initial System Install & Access, 2025-09-25
# Baseline: install essentials, basic config, and ensure network/hostname

# Set hostname (replace with actual device label if needed)
sudo hostnamectl set-hostname srv-m1m-asahi

# Confirm network is up (optional, adjust device name as needed)
ip a

# Collect base system info
cat /etc/os-release
uname -a

# Optionally set static IP (edit or confirm in your network manager)
# nmcli con mod "Wired connection 1" ipv4.addresses 192.168.1.64/24
# nmcli con mod "Wired connection 1" ipv4.gateway 192.168.1.1
# nmcli con mod "Wired connection 1" ipv4.dns 8.8.8.8
# nmcli con mod "Wired connection 1" ipv4.method manual
# nmcli con up "Wired connection 1"

# Log initial users and basic groups
cat /etc/passwd
cat /etc/group

# Create an initial log marker
echo "Initial system baseline completed at $(date)"
