# Complete System Recovery & Restore Procedures

**Version:** 1.0  
**Last Updated:** 2025-11-08  
**Tested:** Monthly (see MONTHLY-TEST-LOG.md)  
**Recovery Time Objective (RTO):** 30 minutes  
**Recovery Point Objective (RPO):** 24 hours  

---

## Overview

This document provides step-by-step procedures for recovering srv-m1m-asahi infrastructure from catastrophic failures.

**Failure Scenarios Covered:**
1. OS SSD corruption or hardware failure
2. External SSD (data) failure or corruption
3. Cache SSD failure
4. Accidental data deletion
5. Complete system loss (fire, theft, natural disaster)

---

## Scenario 1: OS SSD Failure (Most Common)

**Expected Recovery Time:** 30 minutes  
**Data Loss Risk:** None (all data on external SSD)  

### Prerequisites
- Fedora Asahi installation media (USB)
- External SSD `/mnt/data` intact
- Cache SSD `/mnt/fastdata` intact (optional)
- This repository cloned or accessible

### Recovery Steps

#### Step 1: Reinstall Operating System (15 min)

```bash
# Boot from Fedora Asahi USB
# Install to primary M1 SSD
# Create initial user account: sysadmin
# Complete installation, reboot
```

#### Step 2: Mount External SSDs (2 min)

```bash
# Identify device names
lsblk

# Mount data SSD
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data  # Replace with correct device

# Mount cache SSD
sudo mkdir -p /mnt/fastdata
sudo mount /dev/sda1 /mnt/fastdata  # Replace with correct device

# Verify mounts
df -h | grep /mnt
```

#### Step 3: Update /etc/fstab for Auto-Mount (1 min)

```bash
# Get UUIDs
sudo blkid

# Add to /etc/fstab
sudo tee -a /etc/fstab <<EOF
UUID=<data-uuid>     /mnt/data      btrfs  defaults,noatime  0 2
UUID=<fastdata-uuid> /mnt/fastdata  ext4   defaults,noatime  0 2
EOF
```

#### Step 4: Restore User Home Symlinks (1 min)

```bash
# Create system users (if not created during install)
sudo useradd -m -s /bin/zsh ch1ch0
sudo useradd -m -s /bin/zsh trading
sudo useradd -r -s /bin/bash git  # System user for Forgejo

# Remove default home directories
sudo rm -rf /home/sysadmin /home/ch1ch0 /home/trading

# Create symlinks to persistent storage
sudo ln -s /mnt/data/home/sysadmin /home/sysadmin
sudo ln -s /mnt/data/home/ch1ch0 /home/ch1ch0
sudo ln -s /mnt/data/home/trading /home/trading

# Verify
ls -la /home/
```

#### Step 5: Install Dependencies (5 min)

```bash
# Clone infrastructure repo
cd /tmp
git clone https://github.com/ch1ch0-FOSS/srv-m1m-asahi.git

# Install system packages
cd srv-m1m-asahi/00-BOOTSTRAP
sudo bash fedora_bootstrap.sh

# Or install from package list
sudo dnf install -y $(cat packages.txt)
```

#### Step 6: Restore Service Configurations (2 min)

```bash
# Copy systemd service files
sudo cp srv-m1m-asahi/01-FORGEJO/*.service /etc/systemd/system/
sudo cp srv-m1m-asahi/02-VAULTWARDEN/*.service /etc/systemd/system/
sudo cp srv-m1m-asahi/03-SYNCTHING/*.service /etc/systemd/system/

# Copy application configs
sudo mkdir -p /etc/forgejo
sudo cp /mnt/data/backups/latest/app.ini /etc/forgejo/

# Reload systemd
sudo systemctl daemon-reload
```

#### Step 7: Start Services (2 min)

```bash
# Enable and start all services
sudo systemctl enable forgejo syncthing vaultwarden ollama
sudo systemctl start forgejo syncthing vaultwarden ollama

# Verify all services are running
sudo systemctl status forgejo syncthing vaultwarden ollama
```

#### Step 8: Verify System Recovery (2 min)

```bash
# Check service health
systemctl is-active forgejo syncthing vaultwarden ollama

# Test web access
curl -s http://localhost:3100 | grep -q "Forgejo" && echo "Forgejo: OK"
curl -s http://localhost:8384 | grep -q "Syncthing" && echo "Syncthing: OK"
curl -s http://localhost:8000 | grep -q "Vaultwarden" && echo "Vaultwarden: OK"

# Check data integrity
ls -la /mnt/data/srv/forgejo/data/forgejo-repositories/
ls -la /mnt/data/home/
```

**Total Time:** ~30 minutes  
**Result:** System fully operational with zero data loss

---

## Scenario 2: External SSD (Data) Failure

**Expected Recovery Time:** 1-2 hours  
**Data Loss Risk:** Last backup snapshot (max 24 hours)  

### Prerequisites
- Latest backup from `/mnt/data/backups/` (stored elsewhere)
- Replacement external SSD
- This repository

### Recovery Steps

#### Step 1: Replace Failed Drive

```bash
# Connect new external SSD
# Format and partition new drive
sudo fdisk /dev/sdb  # Create primary partition
sudo mkfs.btrfs /dev/sdb1

# Mount new drive
sudo mount /dev/sdb1 /mnt/data
```

#### Step 2: Restore Directory Structure

```bash
# Create standard directories
sudo mkdir -p /mnt/data/{backups,git,home,srv,vault,media,shared}
sudo mkdir -p /mnt/data/srv/{forgejo,syncthing,vaultwarden,ollama}
sudo mkdir -p /mnt/data/home/{sysadmin,ch1ch0,trading}
```

#### Step 3: Restore from Backup

```bash
# Copy latest backup from offsite location
# Example: rsync from backup NAS, cloud storage, or USB drive
rsync -avP /backup-location/forgejo-backup-latest/ /mnt/data/backups/

# Restore Forgejo dump
sudo -u git /usr/bin/forgejo restore \
  --file /mnt/data/backups/latest/forgejo-dump.zip \
  -c /etc/forgejo/app.ini

# Restore user homes (if backed up separately)
rsync -avP /backup-location/home/ /mnt/data/home/

# Restore vault (secrets)
rsync -avP /backup-location/vault/ /mnt/data/vault/
```

#### Step 4: Restart Services

```bash
sudo systemctl restart forgejo syncthing vaultwarden ollama
sudo systemctl status forgejo syncthing vaultwarden ollama
```

**Total Time:** 1-2 hours (depending on backup size)  
**Data Loss:** Up to 24 hours (last backup)

---

## Scenario 3: Cache SSD Failure

**Expected Recovery Time:** 5 minutes  
**Data Loss Risk:** None (cache is non-critical)  

### Recovery Steps

```bash
# Replace failed cache SSD
sudo fdisk /dev/sda
sudo mkfs.ext4 /dev/sda1
sudo mount /dev/sda1 /mnt/fastdata

# Recreate Ollama directory structure
sudo mkdir -p /mnt/fastdata/ollama/{models,cache}

# Copy models from backup (if available)
sudo rsync -a /mnt/data/srv/ollama/models/ /mnt/fastdata/ollama/models/

# Restart Ollama
sudo systemctl restart ollama
```

**Total Time:** 5 minutes  
**Result:** Ollama rebuilds cache on first use

---

## Scenario 4: Accidental Data Deletion

**Expected Recovery Time:** 10-30 minutes  
**Data Loss Risk:** Depends on when deleted  

### For Git Repositories (Forgejo)

```bash
# Restore from latest backup
cd /mnt/data/backups/latest
sudo -u git /usr/bin/forgejo restore --file forgejo-dump.zip
sudo systemctl restart forgejo
```

### For User Files

```bash
# Restore from daily backup
rsync -avP /mnt/data/backups/latest/home/username/ /mnt/data/home/username/
```

---

## Scenario 5: Complete System Loss (Fire, Theft, Natural Disaster)

**Expected Recovery Time:** 2-4 hours  
**Data Loss Risk:** Since last offsite backup  

### Prerequisites
- Offsite backup (cloud, NAS, external USB)
- New hardware (Mac mini or equivalent)
- Fedora Asahi installation media

### Recovery Steps

1. **Acquire new hardware**
2. **Install Fedora Asahi** (follow Scenario 1, Step 1)
3. **Restore from offsite backup** (follow Scenario 2, Step 3)
4. **Recreate infrastructure** (follow Scenario 1, Steps 2-8)

**Total Time:** 2-4 hours  
**Data Loss:** Since last offsite sync (recommend daily)

---

## Backup Verification Checklist

Before disaster strikes, verify:

- [ ] Daily backups run successfully (check `/mnt/data/backups/`)
- [ ] Backup rotation works (old backups pruned)
- [ ] Backups contain all critical data (Git repos, user homes, configs)
- [ ] Offsite backup exists (cloud, NAS, or external USB)
- [ ] Recovery procedures tested monthly (see MONTHLY-TEST-LOG.md)
- [ ] All systemd service files in version control
- [ ] All configs documented and reproducible

---

## Emergency Contacts & Resources

| Resource | Location |
|----------|----------|
| **Infrastructure Repo** | https://github.com/ch1ch0-FOSS/srv-m1m-asahi |
| **Fedora Asahi Installer** | https://asahilinux.org/fedora/ |
| **Backup Location (Primary)** | /mnt/data/backups/ |
| **Backup Location (Offsite)** | [Document your offsite location] |
| **System Admin** | ch1ch0 |

---

## Post-Recovery Validation

After recovery, verify:

```bash
# Services running
systemctl status forgejo syncthing vaultwarden ollama

# Data accessible
ls -la /mnt/data/srv/forgejo/data/forgejo-repositories/
ls -la /mnt/data/home/

# Web interfaces accessible
curl http://localhost:3100  # Forgejo
curl http://localhost:8384  # Syncthing
curl http://localhost:8000  # Vaultwarden

# Users can log in
su - sysadmin
su - ch1ch0
```

---

## Lessons Learned & Improvements

After each recovery drill or real incident, document:
- What went well
- What took longer than expected
- What needs to be improved
- Updates to this procedure

---

**This procedure is tested monthly. See MONTHLY-TEST-LOG.md for test results.**