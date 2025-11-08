# Complete System Recovery Procedure

## Scenario: OS SSD Corruption, Hardware Replacement, or Total System Loss

### Prerequisites
- Fedora Asahi (USB or recovery image)
- External SSD with /mnt/data and /mnt/fastdata
- List of all user accounts and SSH keys
- This repository (srv-m1m-asahi)
- Documented backup from `/mnt/data/backups/`

---

### 1. Reinstall Operating System

1. Download Fedora Asahi ISO and write to USB.
2. Boot from USB, install to primary SSD.
3. Create all necessary system users (sysadmin, ch1ch0, trading).

### 2. Mount External SSDs

1. Attach /mnt/data and /mnt/fastdata drives.
2. Ensure `/etc/fstab` includes correct UUIDs:

UUID=<data-uuid> /mnt/data btrfs defaults,noatime 0 2
UUID=<fastdata-uuid> /mnt/fastdata ext4 defaults,noatime 0 2

3. Mount manually for first boot:

sudo mount /mnt/data
sudo mount /mnt/fastdata

### 3. Restore Home Directory Symlinks

sudo ln -s /mnt/data/home/sysadmin /home/sysadmin
sudo ln -s /mnt/data/home/<user> /home/<user>
sudo ln -s /mnt/data/home/<task> /home/<task>


### 4. Reinstall Dependencies

1. Use `00-BOOTSTRAP/fedora_bootstrap.sh` and `packages.txt`.

### 5. Restore Configuration

1. Copy relevant `/etc/` and `/etc/systemd/system/` files from repo backup.
2. Place config files in `/etc/forgejo/`, `/etc/syncthing/`, etc.

### 6. Restore and Start Services

sudo systemctl daemon-reload
sudo systemctl enable forgejo syncthing vaultwarden ollama
sudo systemctl start forgejo syncthing vaultwarden ollama


### 7. Verify System

- Check service health: `systemctl status forgejo ...`
- Access user data under `/mnt/data`
- Test Forgejo, Syncthing, Vaultwarden, Ollama web endpoints

### 8. Restore From Backup (If Data Loss)

- Use `/mnt/data/backups/forgejo-backup-yyyymmdd/forgejo-dump.zip`
- Run:

sudo -u git /usr/bin/forgejo restore --file /path/to/forgejo-dump.zip
sudo systemctl restart forgejo


### 9. Rotate Secrets (Recommended if rebuild after security incident)

- Regenerate SSH, OAuth, API tokens stored in `/mnt/data/vault/`

---

### Recovery Timeline

- OS install: 15-20 minutes
- Mounting and configuration: 5 minutes
- Service restoration: 5 minutes
- Data verification: 5 minutes

**Expected total recovery: <30-40 minutes**

---

### Maintenance

- Monthly disaster recovery drill
- Quarterly revision/update of this document

