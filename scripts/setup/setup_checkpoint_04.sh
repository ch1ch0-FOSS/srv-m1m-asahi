#!/bin/bash
# system_update_and_tools.sh
# -- Fedora Asahi: Professional sysadmin utilities install & checkpoint documentation

set -e

echo "Updating system package lists..."
sudo dnf upgrade --refresh -y

echo "Installing essential core sysadmin utilities (Fedora Asahi, aarch64)..."
sudo dnf install -y --skip-unavailable \
    dnf \
    htop \
    ncdu \
    wget \
    curl \
    git \
    neovim \
    unzip \
    tar \
    gzip \
    rsync \
    tmux \
    tree \
    lsof \
    net-tools \
    iproute \
    bash-completion \
    sudo \
    findutils \
    plocate \
    du \
    df \
    ps \
    top \
    kill \
    pkill \
    shadow-utils \
    coreutils \
    systemd \
    nmap \
    ansible

echo "Advanced monitoring/automation packages (puppet-agent, nagios-plugins-all, zabbix-agent) are unavailable in Fedora 42 Asahi ARM repos. Consider using containerized alternatives or waiting for repo updates."

echo "Documenting installed package list for reproducibility..."
sudo dnf list installed | sudo tee /var/log/admin_installed_packages_$(date +%F).txt > /dev/null

echo "Checkpoint 04: core sysadmin utilities installation and documentation complete."
