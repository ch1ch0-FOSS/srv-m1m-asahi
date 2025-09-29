#!/bin/bash
# Script Name: setup_checkpoint_X.sh
# Checkpoint: X — Nextcloud Stack Deployment
# Purpose: Deploy full Nextcloud stack (Fedora, local cloud sync, service separation)
# Usage: sudo ./setup_checkpoint_X.sh
# Arguments: None
# Outputs: Logs (install status, verification checks)
# Dependencies: Fedora Asahi Linux, sudo privileges, pre-existing MariaDB (Forgejo safe)
# Maintainer: ch1ch0
# Last Modified: 2025-09-28

# --- Logging Setup ---
LOG_DIR="${HOME}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)_$(date +%Y-%m-%d_%H-%M-%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== $(basename "$0") started at $(date) ==="

# --- Install Nextcloud & Dependencies ---
sudo dnf install -y nextcloud mariadb-server php php-fpm php-mysqlnd php-gd php-xml php-mbstring php-intl php-json php-zip redis nginx policycoreutils-python-utils firewalld

# --- Enable/Start Services ---
sudo systemctl enable --now httpd mariadb php-fpm redis firewalld

# --- Create Nextcloud DB/User (non-disruptive) ---
DB_PASS="REPLACE_THIS_WITH_SECURE_PASSWORD"
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'nextcloud'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EOF

# --- Set Permissions & SELinux ---
sudo chown -R apache:apache /var/lib/nextcloud /etc/nextcloud
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/lib/nextcloud(/.*)?"
sudo restorecon -Rv /var/lib/nextcloud

# --- Status Checks ---
echo "Service Status:"
sudo systemctl status httpd mariadb php-fpm redis firewalld

echo "Verify MariaDB Databases:"
sudo mysql -u root -e "SHOW DATABASES;"

echo "Nextcloud should be accessible via web UI: http://<LAN_IP>/nextcloud"
echo "=== $(basename "$0") ended at $(date) ==="
