#!/usr/bin/env bash
# /mnt/data/scripts/backup_nextcloud.sh
set -euo pipefail

# Config
BACKUP_ROOT="/mnt/data/backups/nextcloud"
NC_DIR="/var/www/nextcloud"            # adjust if different
NC_USER="apache"                       # Fedora/HTTPD user; use "nginx" if applicable
DB_NAME="nextcloud"
DB_USER="root"                         # or service user
DB_CNF="/root/.my.cnf"                 # preferred: credentials here
RETENTION_DAYS="${RETENTION_DAYS:-14}"

NOW="$(date +%Y%m%d-%H%M%S)"
DEST_DIR="${BACKUP_ROOT}/${NOW}"
mkdir -p "${DEST_DIR}"

pushd "${NC_DIR}" >/dev/null

echo "[INFO] Enabling maintenance mode"
sudo -u "${NC_USER}" php occ maintenance:mode --on

echo "[INFO] Dumping database"
mysqldump --defaults-file="${DB_CNF}" "${DB_NAME}" | zstd -19 -T0 -o "${DEST_DIR}/nextcloud-db-${NOW}.sql.zst"

echo "[INFO] Archiving config and data pointers"
tar --zstd -cpf "${DEST_DIR}/nextcloud-config-${NOW}.tar.zst" -C "${NC_DIR}" config
# If data is outside NC_DIR, include that path instead; else capture data directory carefully:
tar --zstd -cpf "${DEST_DIR}/nextcloud-data-${NOW}.tar.zst" -C "${NC_DIR}" data

echo "[INFO] Disabling maintenance mode"
sudo -u "${NC_USER}" php occ maintenance:mode --off

popd >/dev/null

# Prune
find "${BACKUP_ROOT}" -maxdepth 1 -type d -mtime +${RETENTION_DAYS} -print -exec rm -rf {} ;

echo "[OK] Nextcloud backup complete at ${DEST_DIR}"
