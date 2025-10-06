# Fedora Asahi M1 Server Baseline & Setup (v1.0)

_Audit-ready. FHS-aligned. Current as of 2025-09-18._

***

## 1. System Summary

- **Host:** Mac Mini (Apple Silicon M1)
- **OS:** Fedora Linux Asahi Remix 42, kernel 6.16+
- **Hostname/IP:** srv-m1m-asahi (192.168.1.64, static)
- **Main Storage:** `/mnt/data` (primary SSD), `/mnt/fastdata` (secondary SSD)
- **SELinux:** Enforcing

***

## 2. User Accounts and Privileges

| User      | Home                | Shell         | Sudo   | Purpose              |
|-----------|---------------------|-------------- |--------|----------------------|
| admin     | /home/admin         | /usr/bin/zsh  | Yes    | System admin         |
| ch1ch0    | /home/ch1ch0        | /bin/bash     | Yes    | Daily/personal use   |
| git       | /home/git           | nologin       | No     | Forgejo/Git service  |
| forgejo   | /mnt/data/forgejo   | nologin       | No     | Forgejo app data     |
| nextcloud | /mnt/data/nextcloud | nologin       | No     | Nextcloud app data   |
| trading   | /home/trading       | nologin       | No     | Trading tools/apps   |
| bambulabs | /home/bambulabs     | nologin       | No     | 3D printing          |
| canaan    | /home/canaan        | nologin       | No     | Mining/automation    |

_Only `admin` and `ch1ch0` have sudo rights. All other users are service/data roles._

***

## 3. Security and Access

- **SSH:** Key-based authentication (ed25519), no root login, no password auth.
  ```
  ssh-ed25519 AAAAC3Nza... ch1ch0@duck.com
  ```
- **SELinux:** Always Enforcing. Use `restorecon -Rv ~/.ssh` after .ssh changes.
- **Firewall (firewalld):** Zone `public`. Allow only: SSH (22), HTTP (80), HTTPS (443)
- **Essential commands:**
  ```bash
  sudo firewall-cmd --permanent --add-service={ssh,http,https}
  sudo firewall-cmd --reload
  sudo firewall-cmd --set-log-denied=all
  ```

***

## 4. Filesystem Organization

- **SSD mountpoints:** `/mnt/data`, `/mnt/fastdata`
- **Directory layout (FHS-aligned):**
  - `/mnt/data/srv/[app]`      ← App/service data
  - `/mnt/data/var/lib/[app]`  ← App persistent state
  - `/mnt/data/var/log/[app]`  ← Logs
  - `/mnt/data/etc/[app]`      ← Configs
  - `/mnt/data/archive-old`    ← Previous/legacy installs

***

## 5. Checkpoint Timeline

### 1. Install & Network  
- OS, hostname, static IP; test SSH

### 2. User/SSH/SELinux  
- User/group creation, sudo restrict, key-only SSH, SELinux Enforcing

### 3. Security/Firewall  
- Enable firewalld, audit open services, maintain minimal exposure

### 4. System Update/Essentials  
- Update all; install `htop`, `vim`, `ncdu`, `git`, etc.; log audit with `rpm -qa`

### 5. Sudoers & Group Audit  
- Wheel is only admin/ch1ch0, document/cmd: `sudo -l`, `id admin`

### 6. Storage & Service Setup  
- SSD mounts, create FHS directory structure, archive obsolete data

***

## 6. Service Deployments

### Forgejo  
- Systemd service (user: git), MariaDB backend  
- Repositories/data/logs: `/var/lib/forgejo/data`  
- Web UI: `http://192.168.1.64:3000/`

### Nextcloud  
- RPM, MariaDB, PHP, Redis, SELinux context  
- Data at `/mnt/data/nextcloud`, web: `/nextcloud`  
- Mobile/web sync checked

***

## 7. Guidance & Lessons

- Always run `restorecon` after .ssh or SELinux changes
- Log every change in this file
- Use single-line public keys
- Confirm login and sudo after user/shell/group updates
- Backup `/mnt/data` and DBs often
- Apply these standards to every new app/service
provide me this in a ready to paste copy of these 7. ..... 

if i currently try to copy and paste the provided output in is not in proper .md format

Here is a **ready-to-paste section** for your `system-setup-v1.0.md` in clean and concise Markdown format, with headings and bullet points optimized for readability and retention:

***

## 7. Automated Backup & Restore

### 7.1 Automated Backup

- **Script Path:**  
  `/usr/local/bin/backup_nextcloud_forgejo.sh` – Backs up Nextcloud and Forgejo data, configs, logs, and SQL dumps.
- **Backup Storage:**  
  All backups are timestamped and saved under `/mnt/data/archive-old/`, following FHS (separate folders for each app’s data, configs, logs).
- **Database Dumps:**  
  MySQL/MariaDB databases (`nextcloud`, `nextclouddb`, `forgejo`) are included in every run using `mysqldump`. Files are named by date (e.g., `nextcloud-YYYYMMDD.sql`).
- **Scheduling:**  
  - **Cron:** Daily at 2:30AM.  
    Edit root’s crontab and add:
    ```
    30 2 * * * /usr/local/bin/backup_nextcloud_forgejo.sh
    ```
  - **Systemd timer/service:**  
    Files: `/etc/systemd/system/backup-nextcloud-forgejo.service` and `/etc/systemd/system/backup-nextcloud-forgejo.timer`  
    Enable with:
    ```
    sudo systemctl enable --now backup-nextcloud-forgejo.timer
    ```
- **Backup Logging:**  
  Script output can be appended to `/mnt/data/archive-old/backup.log` for auditing.
- **Credential Handling:**  
  Passwords managed via variable, `.my.cnf`, or vault; not stored in readable scripts.
- **Permissions:**  
  Script and dump files use `chmod 700` for security.

***

### 7.2 Restore Procedures

- **Data Restore Example:**  
  ```
  rsync -a /mnt/data/archive-old/<BACKUP-DIR>/ /mnt/data/srv/nextcloud/
  rsync -a /mnt/data/archive-old/<BACKUP-DIR>/ /mnt/data/var/lib/nextcloud/
  ```
- **Database Restore Example:**  
  ```
  mysql -u root -p nextcloud < /mnt/data/archive-old/nextcloud-YYYYMMDD.sql
  ```
- **Full Restore Guide:**  
  See `/mnt/data/docs/restore.md` for full details.
- **Monthly Restore Test:**  
  Practice test restores regularly and log all findings in `/mnt/data/logs/changelog.md`.

***

### 7.3 Backup Retention & Cleanup

- **Retention:**  
  Backups are periodically reviewed; oldest are deleted as needed to manage disk usage.
- **Cleanup:**  
  (Optional) Use a cron job/script to prune backups older than a set interval.

***

### 7.4 Guidance

- Monitor backup log and verify new backup files after each scheduled run.
- Update this documentation for any change in backup routines, credentials, or policies.
- Extend backup scripts and docs for every new service before going live.

***

**Keep this section in version control. Backup, restore, and retention procedures are critical for continuity and audit compliance.**

***

This section is formatted for direct use in Markdown files and matches sysadmin standards.

***

**References**  
https://www.redhat.com/sysadmin/backups-tar-rsync  
https://wiki.archlinux.org/title/System_administration_best_practicesHere is a ready-to-paste, clean Markdown version of section 7 for your `system-setup-v1.0.md`:

***

## 7. Automated Backup & Restore

### 7.1 Automated Backup

- **Script Path:**  
  `/usr/local/bin/backup_nextcloud_forgejo.sh` – All backup commands for Nextcloud and Forgejo.
- **Backup Storage:**  
  Backups stored in `/mnt/data/archive-old/` using timestamped folders, organized by service per FHS.
- **Database Dumps:**  
  MySQL/MariaDB (`nextcloud`, `nextclouddb`, `forgejo`) using `mysqldump`, named as `name-YYYYMMDD.sql`.
- **Scheduling:**  
    - **Cron:**  
      ```
      30 2 * * * /usr/local/bin/backup_nextcloud_forgejo.sh
      ```
    - **systemd timer:**  
      Enable with:  
      ```
      sudo systemctl enable --now backup-nextcloud-forgejo.timer
      ```
- **Backup Logging:**  
  Script output: `/mnt/data/archive-old/backup.log`.
- **Credential Handling:**  
  Use variables, `.my.cnf`, or vault—not hardcoded in scripts.
- **Permissions:**  
  Scripts and SQL dumps are `chmod 700`.

***

### 7.2 Restore Process

- **Restore Data:**  
  ```
  rsync -a /mnt/data/archive-old/<BACKUP-DIR>/ /mnt/data/srv/nextcloud/
  rsync -a /mnt/data/archive-old/<BACKUP-DIR>/ /mnt/data/var/lib/nextcloud/
  ```
- **Restore Database:**  
  ```
  mysql -u root -p nextcloud < /mnt/data/archive-old/nextcloud-YYYYMMDD.sql
  ```
- **Full Restore Guide:**  
  `/mnt/data/docs/restore.md`
- **Monthly Restore Test:**  
  Required; log in `/mnt/data/logs/changelog.md`.

***

### 7.3 Retention & Cleanup

- Review and prune old backups regularly.
- Scripted auto-cleanup is recommended for long-term servers.

***

### 7.4 Admin Guidance

- Monitor logs (`/mnt/data/archive-old/backup.log`).
- Update this documentation whenever routines are changed.
- Extend backup/config for every deployed service.

***

## 8. Next Steps

- Finalize backup/snapshot scripts and disaster recovery docs
- Audit sudo/groups monthly
- Document new apps/services immediately in this file
- Keep this in version control (Forgejo/Nextcloud)

***

**Use this version as your single, authoritative system-setup baseline for audits, onboarding, and recovery. It is fully aligned with modern sysadmin best practices and ready to paste and track in your team's documentation.**


