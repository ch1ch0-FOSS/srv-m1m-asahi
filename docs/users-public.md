# SSH User \& Access Inventory – Administrative Edition

**Project:** `srv‑m1m‑asahi (Fedora Asahi M1)`
**Path:** `/mnt/data/admin/docs/users.md`
_Last Updated: 2025‑10‑25_
_(Internal Use Only — Contains Sensitive Audit Data)_

***

\#\# Purpose

This document serves as the canonical source of all user accounts, groups, UID assignments, SSH key fingerprints, and authentication data for local administration.
It is *private* and must **never** be pushed to Forgejo or GitHub. 
All entries must reflect the current state of `/etc/passwd`, `/etc/group`, and `/home/*/.ssh/authorized_keys`.

Audit frequency: **Monthly** (Manual Review).

***

\#\# User Inventory (Complete)


| Username | UID | GID | Home Directory | Shell | Sudo | Role | Notes |
| :-- | :-- | :-- | :-- | :-- | :-- | :-- | :-- |
| `admin` | 1001 | 1001 | `/home/admin` | `/usr/bin/zsh` | Yes | Primary SysAdmin | Wheel group member |
| `ch1ch0` | 1000 | 1000 | `/home/ch1ch0 → /mnt/data/ch1ch0` | `/bin/bash` | Yes | Portfolio / Daily Ops | Multi‑DE active user (GNOME/KDE/Sway) |
| `trading` | 1002 | 1002 | `/home/trading` | `/bin/zsh` | No | OpenBB/Ollama service ops | Headless automation |
| `git` | 985 | 985 | `/home/git` | `/bin/bash` | No | Forgejo service user | Non‑interactive |
| `forgejo` | 986 | 986 | `/mnt/data/forgejo` | `nologin` | No | Forgejo app data holder | Systemd managed |
| `nextcloud` | 987 | 987 | `/mnt/data/nextcloud` | `nologin` | No | Nextcloud service | Systemd managed |


***

\#\# SSH Key Details (Private Audit Table)


| Username | Key Type | Fingerprint (sha256) | Comment / Label | Date Added | Notes |
| :-- | :-- | :-- | :-- | :-- | :-- |
| `ch1ch0` | ed25519 | `SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` | `ch1ch0@duck.com` | 2025‑10‑04 | Primary admin/user key |
| `admin` | ed25519 | `SHA256:yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy` | `local admin key` | 2025‑10‑04 | Stored in `.ssh/authorized_keys` |
| `trading` | rsa 4096 | `SHA256:zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz` | `trading@localhost` | 2025‑10‑18 | Restricted service key |
| `git` | rsa 4096 | `SHA256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa` | `forgejo service` | Auto‑generated on install | Disabled shell login |


***

\#\# Verification Commands (Audit Reference)

```bash
# List system accounts
getent passwd | awk -F: '{print $1 "\t" $6 "\t" $7}' | column -t

# Check wheel members
grep wheel /etc/group

# Fingerprint keys
ssh-keygen -lf /home/<user>/.ssh/authorized_keys
```


***

\#\# Directory \& Permissions Summary


| Path | Owner | Group | Mode | Purpose |
| :-- | :-- | :-- | :-- | :-- |
| `/home/admin → /mnt/data/admin` | admin | admin | 700 | Local root‑equivalent repo and configs |
| `/home/ch1ch0 → /mnt/data/ch1ch0` | ch1ch0 | ch1ch0 | 755 | Portfolio workspace and docs |
| `/home/trading → /mnt/data/trading` | trading | trading | 750 | Trading automation sandbox |
| `/mnt/data/srv‑m1m‑asahi` | root | admin | 755 | Public project repo for Forgejo and GitHub sync |


***

\#\# Service Account Separation

- Each user/service runs under its own UID/GID pair for process isolation.
- Legacy accounts (`canaan`, `bambulabs`) **removed** on 2025‑10‑24.
- No shared keys or passwords between users.
- `sudoers` restricted to `admin` and `ch1ch0`.

***

\#\# Security Policy Notes

- Root login permanently disabled (`PermitRootLogin no`).
- SELinux enforcing; audit logs monitored monthly.
- SSH uses `ed25519`; no RSA below 4096 bits.
- Use `fail2ban` for endpoint protection (optional).
- Rotate keys annually or upon staff change.

***

\#\# Public Synchronization Guidelines

When creating the public `/srv‑m1m‑asahi/docs/users.md`, redact:
1. All UIDs/GIDs.
2. All key fingerprints and comments.
3. Any personal or email identifiers.
4. Note only roles and access methods.

Example public row (derived from private data):

```markdown
| ch1ch0 | /home/ch1ch0 | /bin/bash | Portfolio User | Yes | Key‑only SSH |
```


***

**File Retention:** Do not include this file in public Git commits.
If synced via Forgejo automation, add to `.gitignore_admin` as:

```
# Sensitive Security Docs
docs/users.md
*.key
*.cred
```


***

**Status:** _Canonical admin version complete — approved for local storage under /mnt/data/admin/docs/_

***

