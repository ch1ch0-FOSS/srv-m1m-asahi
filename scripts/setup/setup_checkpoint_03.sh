#!/bin/bash
# Checkpoint 03: Firewall & Security, 2025-09-25
# Enable firewalld, restrict to SSH, HTTP, HTTPS; enable SELinux enforcing mode

sudo dnf install -y firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld

sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

sudo setenforce 1
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

getenforce
