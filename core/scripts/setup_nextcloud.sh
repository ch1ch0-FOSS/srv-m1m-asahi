#!/usr/bin/env bash
set -euo pipefail

# Configuration
NEXTCLOUD_DIR="/var/www/html/nextcloud"
DB_NAME="nextcloud"
DB_USER="ch1ch0"
DB_PASS="YukFuu247"
ADMIN_USER="ch1ch0"
ADMIN_PASS="YukFuu247"

# Install MariaDB user and database
sudo mysql -u root -p -e "
DROP DATABASE IF EXISTS ${DB_NAME};
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;"

# Fix permissions on Nextcloud directory
sudo chown -R apache:apache "${NEXTCLOUD_DIR}"
sudo find "${NEXTCLOUD_DIR}" -type d -exec chmod 750 {} \;
sudo find "${NEXTCLOUD_DIR}" -type f -exec chmod 640 {} \;

# Run Nextcloud install command
sudo -u apache php "${NEXTCLOUD_DIR}/occ" maintenance:install \
  --database "mysql" \
  --database-name "${DB_NAME}" \
  --database-user "${DB_USER}" \
  --database-pass "${DB_PASS}" \
  --admin-user "${ADMIN_USER}" \
  --admin-pass "${ADMIN_PASS}"

# Rescan files to register existing user data (if any)
sudo -u apache php "${NEXTCLOUD_DIR}/occ" files:scan --all

echo "Nextcloud installation and database setup complete."
echo "Admin username: ${ADMIN_USER}"
echo "Admin password: ${ADMIN_PASS}"

