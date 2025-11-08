# Linux Filesystem Hierarchy Standard (FHS) – Professional Infrastructure Guide

**Version:** 1.0  
**Last Updated:** 2025-11-07  
**Author:** ch1ch0 (Infrastructure Portfolio)  
**Purpose:** Canonical reference for filesystem organization, data-device separation, and operational consistency across srv-m1m-asahi infrastructure.

---

## Executive Summary

This guide enforces **Filesystem Hierarchy Standard (FHS) compliance** across your infrastructure, with emphasis on:
- **Data-device separation:** OS on root device; persistent data on external SSD (`/mnt/data`)
- **Service isolation:** All service data under `/mnt/data/srv/` with systemd management
- **User data persistence:** Home directories symlinked to `/mnt/data/home/`
- **Professional hygiene:** No organizational ambiguity; every directory has a clear purpose

**Adherence to this standard ensures:** system stability, disaster recovery readiness, reproducibility, and portfolio-grade infrastructure maturity.

---

## Part 1: FHS Core Principles

### 1.1 What is FHS?

The **Filesystem Hierarchy Standard (FHS)** defines the directory structure and directory contents in Unix-like operating systems. It ensures:
- Predictable locations for files and directories
- System stability and compatibility across Linux distributions
- Maintainability and handoff clarity
- Reduced system administration overhead

**FHS Version:** 3.0 (Official: https://refspecs.linuxfoundation.org/FHS_3.0/)

---

### 1.2 Core FHS Principles

| Principle | Implication | Your Implementation |
|-----------|-------------|---------------------|
| **Minimal Root (`/`)** | Keep root clean; only OS essentials | OS device contains only system files |
| **Static vs. Variable Separation** | Binaries/libs separate from logs/data | `/usr` and `/var` on OS device; `/mnt/data` for persistence |
| **Mount Point Flexibility** | Directories can live on separate partitions/drives | User homes and services on external SSD via `/mnt/data` |
| **User Data Segregation** | Personal data isolated from system | `/mnt/data/home/` for user files; `/mnt/data/srv/` for services |
| **System Security** | Respect permissions; avoid root writes to user space | Separate users for services (git, ollama); sudo where needed |
| **Predictability** | Everyone knows where to find things | Every directory has explicit purpose; no ambiguity |

---

## Part 2: FHS Directory Reference

### 2.1 Root Device (OS Only) – `/`

| Directory | Purpose | FHS Status | Your Practice |
|-----------|---------|-----------|----------------|
| `/` | Root filesystem | ✅ Keep minimal | OS essentials only |
| `/bin` | Essential user binaries | ✅ FHS | Core commands (bash, ls, etc.) |
| `/sbin` | System administration binaries | ✅ FHS | Root-level utilities |
| `/boot` | Bootloader and kernel | ✅ FHS | Leave untouched |
| `/dev` | Device files | ✅ FHS | System managed |
| `/etc` | System configuration files | ✅ FHS | **All service configs here** (Forgejo, Ollama, systemd) |
| `/home` | User home directories | ✅ FHS | **Symlinks to `/mnt/data/home/`** (see 2.2) |
| `/lib`, `/lib64` | Essential shared libraries | ✅ FHS | System managed |
| `/media` | Auto-mounted removable media | ✅ FHS | USB drives, external media |
| `/mnt` | Manual mount points | ✅ FHS | **External SSD mounted here** (see 2.2) |
| `/opt` | Optional third-party software | ✅ FHS | Minimal use; prefer `/usr/local` |
| `/proc` | Virtual filesystem (process info) | ✅ FHS | System managed |
| `/run` | Runtime state since last boot | ✅ FHS | System managed |
| `/srv` | Service data (on root) | ⚠️ FHS | **Keep empty; use `/mnt/data/srv/` instead** |
| `/sys` | Virtual filesystem (kernel/hardware) | ✅ FHS | System managed |
| `/tmp` | Temporary files | ✅ FHS | **Cleared on reboot; temp work only** |
| `/usr` | Secondary hierarchy (programs, docs) | ✅ FHS | System managed; leave untouched |
| `/var` | Variable data (logs, caches, spool) | ✅ FHS | **Logs on root device** (e.g., `/var/log`) for OS stability |

---

### 2.2 Persistent Data Storage – `/mnt/data` (External SSD)

**Principle:** All long-term, user-owned, or service-specific data lives on external SSD to survive OS reinstalls and system failures.

| Directory | Purpose | Owner | Access |
|-----------|---------|-------|--------|
| `/mnt/data/backups/` | Backup archives (daily Forgejo dumps) | root | Automated via systemd timer |
| `/mnt/data/git/` | All version-controlled repositories | git (Forgejo) | All users read; git user write |
| `/mnt/data/git/ch1ch0-FOSS/` | Infrastructure portfolio (public) | git | Mirror to GitHub |
| `/mnt/data/git/srv-m1m-asahi/` | Infrastructure docs & scripts (private Forgejo) | git | Local-first workflow |
| `/mnt/data/git/ch1ch0.me/` | Portfolio website source | git | Mirror to GitHub → Vercel |
| `/mnt/data/home/` | User home directories | user | Symlinked to `/home/` |
| `/mnt/data/home/sysadmin/` | Admin user workspace | sysadmin | SSH-accessible, persistent |
| `/mnt/data/home/ch1ch0/` | Your personal workspace | ch1ch0 | Primary development environment |
| `/mnt/data/home/trading/` | Trading analysis workspace | trading | Isolated trading tools & data |
| `/mnt/data/media/` | Large media files (photos, docs) | sysadmin | Archive storage |
| `/mnt/data/projects/` | Non-git development work | varies | Shared workspace (optional) |
| `/mnt/data/projects/shared/` | Shared development files | varies | Accessible to all users |
| `/mnt/data/shared/` | System-wide shared data | root | Ollama models, zettelkasten |
| `/mnt/data/srv/` | **Service persistent data** | varies | See 2.3 |
| `/mnt/data/vault/` | Encrypted credentials & secrets | root (600) | High-security storage; never commit |
| `/mnt/data/vault/api-keys/` | API keys (encrypted) | root (600) | Encrypted at rest |
| `/mnt/data/vault/credentials/` | Service credentials | root (600) | Encrypted at rest |
| `/mnt/data/vault/secrets/` | General secrets | root (600) | Encrypted at rest |

---

### 2.3 Service Data – `/mnt/data/srv/` (External SSD)

**Principle:** Each service runs under a dedicated system user; all persistent service data lives in `/mnt/data/srv/<service>/`.

| Service | Directory | Systemd User | Access Pattern | Data |
|---------|-----------|--------------|-----------------|------|
| **Forgejo** | `/mnt/data/srv/forgejo/` | `git` | HTTP (3100) | Git repos, DB, configs |
| `forgejo/data/` | Repo storage | | | `/mnt/data/srv/forgejo/data/forgejo-repositories/` |
| `forgejo/data/log/` | Service logs | | | Rotated in `/mnt/data/srv/forgejo/data/log/` |
| **Syncthing** | `/mnt/data/srv/syncthing/` | `root` (Podman) | HTTP (8384) | Sync state, peer config |
| `syncthing/data/` | Sync metadata | | | File sync state, device config |
| `syncthing/config/` | Syncthing config | | | `config.xml` and TLS certs |
| **Vaultwarden** | `/mnt/data/srv/vaultwarden/` | `root` (Podman) | HTTP (8000) | Password vault DB |
| `vaultwarden/data/` | Vault storage | | | SQLite DB, attachments |
| **Ollama** | `/mnt/data/srv/ollama/` | `ollama` | HTTP (11434) | LLM models & cache |
| `ollama/models/` | Downloaded models | | | Large model files (10GB+) |
| `ollama/data/` | Ollama state | | | Model metadata, caches |

**Systemd Service Pattern:**
```ini
# Example: Forgejo
WorkingDirectory=/mnt/data/srv/forgejo
Environment=FORGEJO_WORK_DIR=/mnt/data/srv/forgejo

# Example: Syncthing (Podman volume mount)
--volume=/mnt/data/srv/syncthing/data:/var/syncthing:Z

# Example: Ollama
Environment=OLLAMA_MODELS=/mnt/data/srv/ollama/models
```

---

### 2.4 System Logs & Runtime (Root Device) – `/var/`

**Principle:** System-critical logs and runtime state stay on root device for OS stability.

| Directory | Content | Persistence | Retention |
|-----------|---------|-------------|-----------|
| `/var/log/` | System logs (kernel, services, auth) | Root device | 7-30 days (logrotate) |
| `/var/log/syslog` | General system log | Root device | Rotated daily |
| `/var/log/auth.log` | Authentication events | Root device | Rotated daily |
| `/var/log/forgejo.log` | Forgejo application log (optional) | Root device | Rotated (or in `/mnt/data/srv/forgejo/data/log/`) |
| `/var/run/` | Runtime state since last boot | Root device | Cleared on reboot |
| `/var/tmp/` | Temporary files (preserved across reboots) | Root device | Cleared periodically |

**Best Practice:** Let systemd manage service logs via `journald`:
```bash
# View Forgejo logs
sudo journalctl -u forgejo -f

# View Syncthing logs
sudo journalctl -u syncthing -f
```

---

## Part 3: Your Infrastructure Architecture

### 3.1 Storage Layout

```
Physical Hardware
├─ Root Device (M1 SSD)
│  ├─ / (OS and system essentials)
│  ├─ /etc (configs)
│  ├─ /var (logs, runtime)
│  └─ /tmp (temp files, cleared on reboot)
│
└─ External SSD (/mnt/data) – 7.28 TiB
   ├─ backups/ (Forgejo backups)
   ├─ git/ (all repositories)
   ├─ home/ (user homes, symlinked)
   ├─ media/ (large files)
   ├─ projects/ (non-git work)
   ├─ shared/ (system-wide data)
   ├─ srv/ (service persistent data)
   └─ vault/ (encrypted credentials)
```

---

### 3.2 User Homes – Symlink Pattern

**Root Device `/home/` :**
```
/home/
├─ git → (system user, minimal home)
├─ sysadmin → /mnt/data/home/sysadmin (symlink)
├─ ch1ch0 → /mnt/data/home/ch1ch0 (symlink)
└─ trading → /mnt/data/home/trading (symlink)
```

**Why Symlinks?**
- ✅ Users can SSH/login and access persistent data
- ✅ Homes survive OS reinstalls
- ✅ Clear separation: OS on root, data on external SSD
- ✅ Professional data-device separation

**Symlink Creation (already done):**
```bash
sudo ln -s /mnt/data/home/sysadmin /home/sysadmin
sudo ln -s /mnt/data/home/ch1ch0 /home/ch1ch0
sudo ln -s /mnt/data/home/trading /home/trading
```

---

### 3.3 Service Organization

**All services follow this pattern:**

1. **Systemd Service File** – `/etc/systemd/system/<service>.service`
   - Defines how service runs
   - Points to persistent data in `/mnt/data/srv/<service>/`

2. **Service Data** – `/mnt/data/srv/<service>/`
   - All persistent data for the service
   - Owned by service user (git, ollama, root)
   - Survives OS reinstalls

3. **Configuration** – `/etc/<service>/` (if app-specific)
   - Example: `/etc/forgejo/app.ini`
   - Symlinks to data directory if needed

---

## Part 4: Operational Standards

### 4.1 Adding New Services

When deploying a new service:

1. **Create service directory** under `/mnt/data/srv/`
   ```bash
   sudo mkdir -p /mnt/data/srv/<servicename>/{data,config}
   ```

2. **Create systemd unit** in `/etc/systemd/system/<servicename>.service`
   - Point `WorkingDirectory=` to `/mnt/data/srv/<servicename>/`
   - Set `User=` to dedicated system user

3. **Update service config** to reference `/mnt/data/srv/<servicename>/` paths

4. **Document** in infrastructure repo (`srv-m1m-asahi`)

### 4.2 Backup & Disaster Recovery

**Backup Strategy:**
- **What:** All data in `/mnt/data/` (user homes, services, git, vault)
- **Frequency:** Daily automated snapshots
- **Location:** `/mnt/data/backups/`
- **Retention:** Last 7 days + weekly/monthly archives
- **Testing:** Monthly restore drills

**What NOT to back up:**
- `/tmp/` (temporary, cleared on reboot)
- `/var/log/` (system logs, rotated)
- `/var/run/` (runtime state, cleared on reboot)
- Root device `/` (OS can be reinstalled)

---

### 4.3 Permissions & Ownership

| Path | Owner | Permissions | Reason |
|------|-------|-------------|--------|
| `/mnt/data/home/<user>/` | user:user | 755 | User workspace |
| `/mnt/data/srv/forgejo/` | git:git | 750 | Service isolation |
| `/mnt/data/srv/syncthing/` | root:root | 755 | Podman container root |
| `/mnt/data/vault/` | root:root | 700 | Encrypted secrets |
| `/mnt/data/backups/` | root:root | 700 | Backups (root-owned) |

**Check permissions:**
```bash
ls -la /mnt/data/
stat /mnt/data/srv/forgejo/
getfacl /mnt/data/vault/
```

---

### 4.4 Mount Verification

**On system boot, verify mounts:**
```bash
# Check if external SSD is mounted
mount | grep /mnt/data

# If not mounted, mount manually
sudo mount /mnt/data  # assumes fstab entry exists

# Verify via df
df -h /mnt/data
```

**Add to `/etc/fstab` for automatic mount:**
```
# External SSD (example UUID)
UUID=abc123def456 /mnt/data btrfs defaults,noatime 0 2
```

---

## Part 5: FHS Compliance Checklist

Use this checklist to audit your system:

- [ ] **Root device (`/`) contains only OS files** – No user data
- [ ] **All user homes symlinked** – `/home/<user>` → `/mnt/data/home/<user>`
- [ ] **All service data in `/mnt/data/srv/`** – Forgejo, Syncthing, Vaultwarden, Ollama
- [ ] **No data in `/opt/`** – Cleaned up, only system packages if needed
- [ ] **`/var/` on root device** – Logs and runtime state for OS stability
- [ ] **`/tmp/` cleared on reboot** – No persistent files
- [ ] **`/etc/` contains all configs** – Forgejo, systemd units, etc.
- [ ] **Service users have minimal homes** – Only `.ssh` for system users (git, ollama)
- [ ] **Backups target `/mnt/data/` only** – Not OS device
- [ ] **Mounts documented** – `/etc/fstab` or systemd automount
- [ ] **Permissions enforced** – Users own their homes; services own their data
- [ ] **Documentation maintained** – This guide, systemd units, installation scripts

---

## Part 6: Common FHS Compliance Scenarios

### Scenario 1: "Where should I put my new project?"

**Answer:** `/mnt/data/git/<projectname>/` if versioned in Forgejo, or `/mnt/data/projects/<projectname>/` if not yet under version control.

```bash
# Versioned in git (recommended)
cd /mnt/data/git
mkdir my-new-project
cd my-new-project
git init
# → Create Forgejo repo and push

# Non-versioned (temporary)
mkdir -p /mnt/data/projects/my-experiment
# → Move to git once stable
```

---

### Scenario 2: "Where do I store database backups?"

**Answer:** `/mnt/data/backups/` with date-stamped directory.

```bash
sudo mkdir -p /mnt/data/backups/$(date +%Y%m%d-%H%M%S)
sudo forgejo dump -c /etc/forgejo/app.ini -o /mnt/data/backups/$(date +%Y%m%d-%H%M%S)/forgejo-backup.zip
```

---

### Scenario 3: "My service needs new persistent storage. Where goes it?"

**Answer:** Under `/mnt/data/srv/<servicename>/`. Update systemd `WorkingDirectory=` and environment variables.

```bash
# Example: Adding new storage for Ollama models
sudo mkdir -p /mnt/data/srv/ollama/models
sudo chown -R ollama:ollama /mnt/data/srv/ollama

# Update systemd unit
sudo nano /etc/systemd/system/ollama.service
# Add: Environment=OLLAMA_MODELS=/mnt/data/srv/ollama/models

sudo systemctl daemon-reload
sudo systemctl restart ollama
```

---

### Scenario 4: "OS device is getting full. How do I move things to external SSD?"

**Answer:** Migrate to `/mnt/data/`, create symlinks, update service configs.

```bash
# Move user data
sudo rsync -a /home/<user>/ /mnt/data/home/<user>/
sudo rm -rf /home/<user>
sudo ln -s /mnt/data/home/<user> /home/<user>

# Update service to use /mnt/data/srv instead of /var/lib
# Update systemd WorkingDirectory=
# Restart service
```

---

## Part 7: Troubleshooting & Validation

### Check FHS Compliance

```bash
# Verify root device is clean (OS only)
du -sh / | head -20

# Check external SSD is mounted
mount | grep /mnt/data

# Verify user homes are symlinks
ls -la /home/

# Check service data locations
ls -la /mnt/data/srv/

# Verify vault is secure
stat /mnt/data/vault/
```

### Common Issues & Fixes

| Issue | Root Cause | Fix |
|-------|-----------|-----|
| Service fails to start | Systemd `WorkingDirectory` doesn't exist | Create directory; update path to `/mnt/data/srv/` |
| User can't access home | Symlink broken | Recreate symlink: `sudo ln -s /mnt/data/home/<user> /home/<user>` |
| Backup fails | `/mnt/data/backups/` full or missing | Verify mount exists; clean old backups |
| OS device full | Too much data on root | Move data to `/mnt/data/`; create symlinks |

---

## Part 8: References & Further Learning

### Official Standards
- [FHS 3.0 Specification](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html) – Linux Foundation
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf) – PDF Reference

### Fedora/RHEL Documentation
- [Red Hat – Filesystem Structure](https://docs.redhat.com/en/documentation)
- [Fedora – File System Organization](https://docs.fedoraproject.org/)

### Professional Resources
- [Linux Journal – Filesystem Hierarchy](https://www.linuxjournal.com/)
- [The Linux Documentation Project (TLDP)](https://www.tldp.org/)

---

## Appendix A: Quick Reference Card

```
ROOT DEVICE (/)              | EXTERNAL SSD (/mnt/data)
─────────────────────────────────────────────────────────
/bin, /sbin, /usr            | /git (repositories)
/etc (configs)               | /home (user homes, symlinked)
/var (logs, runtime)         | /srv (service data)
/tmp (temp, cleared)         | /backups (archives)
                             | /vault (encrypted secrets)
                             | /media (large files)
                             | /projects (dev work)
```

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-07 | ch1ch0 | Initial comprehensive guide combining FHS standards with infrastructure architecture |

---

**Last Updated:** 2025-11-07 21:40 PST  
**Status:** OPERATIONAL – This document is the canonical reference for filesystem organization on srv-m1m-asahi.  
**Review Cycle:** Quarterly or when infrastructure changes  
**Owner:** ch1ch0 (System Administrator)