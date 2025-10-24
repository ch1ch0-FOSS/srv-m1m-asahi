#!/bin/bash
set -euo pipefail

TODAY="$(date +'%Y%m%d_%H%M')"
ARCHIVE_ROOT="/mnt/data/archive-old"
SNAPSHOT_ROOT="/mnt/fastdata/snapshots"
# Nextcloud and Forgejo database names and config—edit as needed
MYSQL_USER="root"
# Could be 'nextcloud' or whatever your DB is named
NC_DB="nextcloud"
FORGEJO_DB="forgejo" 

# 1. BTRFS snapshots (read-only, safe for backup)
sudo btrfs subvolume snapshot -r /mnt/data "$SNAPSHOT_ROOT/data-$TODAY"

# 2. Rsync main data backup (Nextcloud/Forgejo data/config/logs)
rsync -aAX --delete /mnt/data/  "$ARCHIVE_ROOT/data-backup-$TODAY/"
rsync -aAX --delete /mnt/fastdata/  "$ARCHIVE_ROOT/fastdata-backup-$TODAY/"

# 3. Dump MySQL/MariaDB databases (requires ~/.my.cnf or secure password handling)
mysqldump -u "$MYSQL_USER" "$NC_DB" > "$ARCHIVE_ROOT/nextcloud-$TODAY.sql"
mysqldump -u "$MYSQL_USER" "$FORGEJO_DB" > "$ARCHIVE_ROOT/forgejo-$TODAY.sql"

# 4. Log completion
echo "Backup completed $TODAY by $(whoami)" >> "$ARCHIVE_ROOT/backup.log"
