# Fedora/Asahi Server Baseline Configuration  
**Checkpoint:** Secure Shell/Firewall/Post-Install Baseline  
**Date:** 2025-09-25

***

## System Overview

- **Base OS:** Fedora Linux Asahi Remix 42 (`srv-m1m-asahi`)
- **Kernel:** Asahi 6.16+
- **Host:** Apple Silicon (M1)
- **Network:** 192.168.1.64 (static/local)

***

## User Accounts and Privileges

| Username  | UID  | Home Directory      | Shell         | Sudo/Admin |
|-----------|------|---------------------|---------------|------------|
| admin     | 1001 | /home/admin         | /usr/bin/zsh  | Yes        |
| ch1ch0    | 1000 | /home/ch1ch0        | /bin/bash     | Yes        |
| forgejo   |      | /mnt/data/forgejo   |               |            |
| nextcloud |      | /mnt/data/nextcloud |               |            | 
| git       |      | /home/git           |               |            | 
| trading   |      | /home/trading       |               |            | 
| bambulabs |      | /home/bambulabs     |               |            | 
| canaan    |      | /home/canaan        |               |            | 


***

## SSH Security

- **Key-Based Authentication:** Enabled, only matching public keys (ed25519).
- **Users Configured:** `admin`, `ch1ch0`
- **SSH Daemon Config Changes:**  
  - `PermitRootLogin no`  
  - `PasswordAuthentication no` (when keys are confirmed working)
  - `AuthorizedKeysFile .ssh/authorized_keys`

#### Current authorized_keys sample:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvDSBqI7ED/V/E3... ch1ch0@duck.com
```

***

## SELinux Status
- `getenforce` returns: **Enforcing**  
  Reset with: `restorecon -Rv ~/.ssh` after any manual changes.

***

## Firewall Configuration (firewalld)

- **Zone:** public (default, active)
- **Interface protected:** end0
- **Open Services:**  
  - SSH (port 22)
  - HTTP (port 80, for future web services)
  - HTTPS (port 443, for future web services)

#### Applied Commands:
```bash
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --set-default-zone=public
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
sudo firewall-cmd --set-log-denied=all
sudo firewall-cmd --list-all
sudo firewall-cmd --get-active-zones
```

***

## Key System Commands Used

```bash
# User creation and shell setup (example)
sudo useradd -m -s /usr/bin/zsh admin
sudo usermod -aG wheel admin
sudo useradd -m -s /bin/bash ch1ch0
sudo usermod -aG wheel ch1ch0

# SSH Key checks and sync
ssh-keygen -lf ~/.ssh/id_ed25519
cat ~/.ssh/authorized_keys

# SELinux and permissions
restorecon -Rv ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

***

## Lessons Learned / Gotchas

- Always use single-line public keys in `authorized_keys`.
- SELinux can break SSH even with perfect permissions—run `restorecon` after any manual edit.
- Track all admin and shell changes in SYSTEM_SETUP.md for future reference.
- Always verify logins (ssh, sudo) after changes to users, shell, keys, or firewall.

***

## Next Steps / TODO

- System update and baseline package install: `sudo dnf update -y`
- Document sudoer setup and audit groups.
- Prepare for Forgejo and Nextcloud installs; plan their /srv and /var/data directories.
- Continue updating this document with every tested/configured tool or security change.

