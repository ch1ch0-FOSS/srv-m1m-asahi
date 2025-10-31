#!/usr/bin/env bash
# /mnt/data/scripts/backup_forgejo_dump.sh
set -euo pipefail

# Config
BACKUP_ROOT="/mnt/data/backups/forgejo"
RUN_AS_USER="git"              # system user owning Forgejo service
FORGEJO_BIN="/usr/local/bin/forgejo"  # adjust if different
RETENTION_DAYS="${RETENTION_DAYS:-14}"  # prune old dumps

# Prep
NOW="$(date +%Y%m%d-%H%M%S)"
DEST_DIR="${BACKUP_ROOT}/${NOW}"
mkdir -p "${DEST_DIR}"

# Dump
echo "[INFO] Starting Forgejo dump at ${NOW}"
sudo -u "${RUN_AS_USER}" "${FORGEJO_BIN}" dump --type tar.zst -f "${DEST_DIR}/forgejo-dump-${NOW}.tar.zst" -V

# Verify
ls -lh "${DEST_DIR}"

# Prune
find "${BACKUP_ROOT}" -maxdepth 1 -type d -mtime +${RETENTION_DAYS} -print -exec rm -rf {} ;

echo "[OK] Forgejo dump complete: ${DEST_DIR}/forgejo-dump-${NOW}.tar.zst"
