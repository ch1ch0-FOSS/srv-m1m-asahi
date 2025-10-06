# Restore Procedures for Nextcloud and Forgejo Backups

## Overview
This document describes the tested, step-by-step process to restore Nextcloud and Forgejo services from automated backups stored under `/mnt/data/backups`. Restoration is critical for disaster recovery, audit compliance, and operational continuity.

***

## Nextcloud Restore Steps

1. **Put Nextcloud into maintenance mode before restore** (if system is live):
   ```bash
   sudo -u apache php /usr/share/nextcloud/occ maintenance:mode --on
   ```
2. **Stop web server and related services** (optional but recommended):
   ```bash
   sudo systemctl stop httpd
   sudo systemctl stop php-fpm
   ```
3. **Restore the Nextcloud config and data directories** from backup dated `YYYYMMDD-HHMMSS` (replace accordingly):
   ```bash
   sudo rsync -a --delete "/mnt/data/backups/YYYYMMDD-HHMMSS/nextcloud/config/" /etc/nextcloud/
   sudo rsync -a --delete "/mnt/data/backups/YYYYMMDD-HHMMSS/nextcloud/data/." /usr/share/nextcloud/data/
   ```
4. **Restore the Nextcloud database** dump (decompress as needed):
   ```bash
   zstd -d -c "/mnt/data/backups/YYYYMMDD-HHMMSS/nextcloud/db-YYYYMMDD-HHMMSS.sql.zst" | sudo mysql -u root -p nextcloud
   ```
5. **Set correct ownership and permissions** (example for Fedora Apache PHP setup):
   ```bash
   sudo chown -R apache:apache /usr/share/nextcloud
   sudo chown -R apache:apache /etc/nextcloud
   ```
6. **Disable maintenance mode after restore**:
   ```bash
   sudo -u apache php /usr/share/nextcloud/occ maintenance:mode --off
   ```
7. **Start services**:
   ```bash
   sudo systemctl start httpd
   sudo systemctl start php-fpm
   ```
8. **Run integrity and file scan** to verify restored files:
   ```bash
   sudo -u apache php /usr/share/nextcloud/occ integrity:check-core
   sudo -u apache php /usr/share/nextcloud/occ files:scan --all
   ```

***

## Forgejo Restore Steps

1. **Stop Forgejo service** before restoring:
   ```bash
   sudo systemctl stop forgejo
   ```
2. **Extract the Forgejo dump** archive for backup `YYYYMMDD-HHMMSS`:
   ```bash
   sudo tar -I zstd -xvf "/mnt/data/backups/YYYYMMDD-HHMMSS/forgejo/forgejo-dump-YYYYMMDD-HHMMSS.tar.zst" -C /
   ```
   The dump contains repositories, configs, attachments, DB dumps, and LFS objects.
3. **Verify ownership and SELinux contexts** of restored data:
   ```bash
   sudo chown -R git:git /var/lib/forgejo
   sudo restorecon -Rv /var/lib/forgejo /etc/forgejo
   ```
4. **Start Forgejo service**:
   ```bash
   sudo systemctl start forgejo
   ```
5. **Verify service health**:
   - Check status: `sudo systemctl status forgejo`
   - Confirm web UI access and repository availability.

***

## Notes & Recommendations

- Always test restore in a staging environment periodically to validate backup integrity and restore procedures.
- Log each restore attempt and outcome in `/mnt/data/logs/changelog.md`.
- Keep backup archives rotated and pruned per policy to manage disk usage.
- Align restore and backup tools to maintain FHS compliance and audit readiness.

***
