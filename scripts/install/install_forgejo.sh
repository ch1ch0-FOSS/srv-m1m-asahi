#!/bin/bash
# Script Name: install_forgejo.sh
# Purpose: Automated installation of Forgejo (arm64) on Fedora or similar systems.
# Usage: sudo ./install_forgejo.sh
# Arguments: None
# Outputs: Installation logs, system changes, status messages.
# Dependencies: mariadb-server, git, git-lfs, wget
# Maintainer: ch1ch0
# Last Modified: 2025-10-25

set -euo pipefail

LOG_DIR="${HOME}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/install_forgejo_$(date +%Y-%m-%d_%H-%M-%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1
exec 2> >(tee -a "$LOG_FILE" >&2)
echo "=== install_forgejo.sh started at $(date) ==="

# ---- Dependencies ----
for dep in git git-lfs wget mariadb; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        echo "[INFO] Installing missing dependency: $dep..."
        sudo dnf install -y "$dep"
    fi
done

# ---- System User and Directories ----
sudo useradd --system --shell /bin/bash --comment "Git Version Control" --create-home --home-dir /home/git git || true
sudo mkdir -p /var/lib/forgejo/data/forgejo-repositories /var/lib/forgejo/data/lfs /var/lib/forgejo/data/log
sudo chown -R git:git /var/lib/forgejo

# ---- Forgejo Binary ----
FORGEJO_VER="1.20.1-0"
wget -O /tmp/forgejo-arm64 "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VER}/forgejo-${FORGEJO_VER}-linux-arm64"
sudo mv /tmp/forgejo-arm64 /usr/bin/forgejo
sudo chmod 755 /usr/bin/forgejo

# ---- systemd Service ----
sudo tee /etc/systemd/system/forgejo.service <<EOF
[Unit]
Description=Forgejo (Beyond coding. We forge.)
After=network.target

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/forgejo
Environment=USER=git HOME=/home/git FORGEJO_WORK_DIR=/var/lib/forgejo
ExecStart=/usr/bin/forgejo web --config /etc/forgejo/app.ini
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable forgejo.service

echo "=== install_forgejo.sh ended at $(date) ==="
echo "Forgejo installed, ready for browser setup at http://YOUR_SERVER_IP:3000/"
