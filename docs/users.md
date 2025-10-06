# SSH User and Public Key Inventory

**Project:** srv-m1m-asahi (Fedora Asahi M1)  
**Path:** docs/users.md  
_Last updated: 2025-10-04_

---

## Purpose

This document provides an accurate, up-to-date inventory of user accounts and authorized public SSH keys for this server and is a requirement for world-class audit and security hygiene.  
- Documented after every change to authorized keys or users.
- No private keys or passwords are ever included.

---

## User Inventory (based on /etc/passwd)

| Username  | UID   | Home Dir          | Shell         | Role         |
|-----------|-------|-------------------|---------------|--------------|
| ch1ch0    | 1000  | /home/ch1ch0      | /bin/bash     | Admin/User   |
| admin     | 1001  | /home/admin       | /usr/bin/zsh  | Sysadmin     |
| trading   | 1002  | /home/trading     | /bin/bash     | Trading Ops  |
| bambulabs | 1003  | /home/bambulabs   | /bin/bash     | 3D Print Ops |
| canaan    | 1004  | /home/canaan      | /bin/bash     | Automation   |
| git       | 985   | /home/git         | /bin/bash     | Forgejo Git  |

---

## SSH Key Audit Table

| Username  | Key Type | Fingerprint             | Comment              | Date Added   | Notes                 |
|-----------|----------|-------------------------|----------------------|-------------|-----------------------|
| ch1ch0    | ed25519  | (Run ssh-keygen -lf ...) | ch1ch0#duck.com      | 2025-10-04  | Primary admin login   |
| admin     | —        | —                       | —                    | —           | No key present        |
| trading   | —        | —                       | —                    | —           | No key present        |
| bambulabs | —        | —                       | —                    | —           | No key present        |
| canaan    | —        | —                       | —                    | —           | No key present        |
| git       | —        | —                       | —                    | —           | No key present        |

---

## Details: Active Key Example

### User: ch1ch0

- **Key Type:** ed25519  
- **Public Key:**  

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvDSBqI7ED/V/E3RtZN/jXYwzcKAUUtZXnVKc9PTVys ch1ch0#duck.com

- **Fingerprint:** _(fill using `ssh-keygen -lf /home/ch1ch0/.ssh/authorized_keys`)_  
- **Date Added:** 2025-10-04  
- **Notes:** Primary daily login key

---

## Admin/Change Procedure

- After any change to users or SSH keys, edit this file and log event in `docs/system-setup-v1.0.md` and your changelog.
- Periodically (e.g., quarterly), compare this file against `/etc/passwd`, `/etc/group`, and all `/home/[user]/.ssh/authorized_keys` for consistency.

---

_Never include private information. This file supports audits, onboarding/offboarding, and public proof of system security practice._


