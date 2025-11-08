#!/usr/bin/env bash
#===============================================================================
#  Restore Forgejo from Backup Script
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

BACKUP_PATH="${1:-}"
FORGEJO_USER="git"
SERVICE_NAME="forgejo"
FORGEJO_CONFIG="/etc/forgejo/app.ini"

if [[ -z "$BACKUP_PATH" || ! -f "$BACKUP_PATH" ]]; then
  echo "Usage: $0 /mnt/data/backups/forgejo-backup-YYYYMMDD-HHMMSS/forgejo-dump.zip"
  exit 1
fi

echo "Stopping Forgejo..."
sudo systemctl stop $SERVICE_NAME

echo "Restoring Forgejo from $BACKUP_PATH"
sudo -u $FORGEJO_USER /usr/bin/forgejo restore --file "$BACKUP_PATH" -c "$FORGEJO_CONFIG"

echo "Starting Forgejo..."
sudo systemctl start $SERVICE_NAME

echo "Forgejo restore complete. Check service status:"
sudo systemctl status $SERVICE_NAME

