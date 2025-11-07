# Forgejo Backup & Recovery Strategy

## Overview

Daily automated backups ensure data resilience. Monthly recovery tests validate procedures.

---

## Backup Schedule

- **Frequency**: Daily at 02:00 AM (cron)
- **Retention**: Last 7 daily, last 4 weekly, last 3 monthly
- **Storage**: External SSD mounted at `/mnt/backup/forgejo`

---

## What Gets Backed Up

1. **Repositories**: `/var/lib/forgejo/data/forgejo-repositories`
2. **Database**: MariaDB dump of `forgejo` database
3. **Configuration**: `/etc/forgejo/app.ini`
4. **LFS objects**: `/var/lib/forgejo/data/lfs`

---

## Backup Script (Example)

#!/bin/bash
/usr/local/bin/backup-forgejo.sh

DATE=$(date +%Y-%m-%d)
BACKUP_DIR="/mnt/backup/forgejo/$DATE"
mkdir -p "$BACKUP_DIR"
Dump database

mysqldump -u forgejo -p'PASSWORD' forgejo > "$BACKUP_DIR/forgejo-db.sql"
Copy repos and config

rsync -av /var/lib/forgejo/data/forgejo-repositories "$BACKUP_DIR/"
cp /etc/forgejo/app.ini "$BACKUP_DIR/"

echo "Backup completed: $BACKUP_DIR"


*Cron entry:*  
`0 2 * * * /usr/local/bin/backup-forgejo.sh`

---

## Recovery Procedure

1. Stop Forgejo: `sudo systemctl stop forgejo`
2. Restore database: `mysql -u forgejo -p'PASSWORD' forgejo < forgejo-db.sql`
3. Restore repositories: `rsync -av backup/forgejo-repositories/ /var/lib/forgejo/data/forgejo-repositories/`
4. Restore config: `cp backup/app.ini /etc/forgejo/`
5. Start Forgejo: `sudo systemctl start forgejo`
6. Verify: Access web UI, clone a test repo.

---

## Monthly Test Log

See [restore-test.log](./restore-test.log) for evidence of successful recovery tests.

---

**Last tested:** 2025-11-07  
**Result:** Success – full recovery in under 15 minutes.

