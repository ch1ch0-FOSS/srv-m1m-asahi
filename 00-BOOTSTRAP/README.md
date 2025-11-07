# 00-BOOTSTRAP

**Fedora Asahi Linux Infrastructure Bootstrap – FHS-Compliant, Reproducible, and Secure**

This directory contains a professional, reproducible bootstrap procedure and documentation for building a minimal, hardened Fedora Asahi Linux system for self-hosted infrastructure on Apple Silicon.

---

## Purpose & Philosophy

- _Reproducible_: Bring up a minimal, standards-based server on any fresh Fedora Asahi M1 install with a single script.
- _FHS-Compliant_: Ensures everything (services, logs, configs) follows Linux filesystem hierarchy standards.
- _Security-First_: SSH hardening, firewall, group/user setup, safe permissions.
- _Operable_: Generates audit documentation for what was done, with rollback and next-step guidance.
- _Demonstrable_: Core of your open professional infrastructure, not just another "dotfiles" or rough collection of configs.

---

## Files

- [`fedora_bootstrap.sh`](./fedora_bootstrap.sh): Automated one-shot setup script – can be called manually or via CI/CD/test automation
- `packages.txt`: Bill of materials/all key packages
- *(add others as you build out: install logs, automated test output, etc.)*

---

## Usage

**1. Review the script and this documentation for safety (never run a random script blindly).**  
**2. On a fresh Fedora system:**

As root or a sudoer user:

bash fedora_bootstrap.sh

**3. Script will prompt or require sudo for required actions.**  
**4. Review the output and SYSTEM_SETUP.md for next-steps and audit record.**

> **Expected runtime:** 30–60 minutes for full setup

---

## What This Script Does (At a Glance)

- Updates OS, installs best-practice "starter stack" for devops/admin
- Creates `/srv`, `/etc`, `/opt`, `/var/lib`, `/var/log` service layouts for Forgejo, Nextcloud, Mastodon (modify for your own stack)
- Securely configures SSH, disables root/password logins, generates per-user keys (if needed)
- Enables and configures firewall to only needed ports
- Sets up "admin" and your sysadmin user, adds sudo/wheel group, preferred shell and workspace directories
- Hardens all key filesystem areas (ownership/perms)
- *Generates SYSTEM_SETUP.md documenting exactly what was provisioned/locked down*
- Calls out future manual/service installation steps

---

## Example Directory Layout

/srv/forgejo/ # Git service data
/srv/nextcloud/ # File sharing data
/etc/forgejo/ # Git config
/var/lib/forgejo/ # App/DB runtime data
/var/log/forgejo/ # Application logs
/opt/forgejo/ # Optional binaries/scripts

---

## Rollback & Troubleshooting

- **Backups**: All key config files (e.g. `/etc/ssh/sshd_config`) are backed up before being modified.
- **Idempotency**: Script skips work that doesn't need to be repeated, but use at your own risk if not on a new machine.
- **If interrupted**: Review SYSTEM_SETUP.md, rerun or manually correct as needed.
- **Common failure points**: permission errors, missing root/sudo, network issues, old Fedora base images.
- **For issues:** See `TROUBLESHOOTING.md` in the root of this repo.

---

## Next Steps

After successful bootstrap:
1. Go to `01-FORGEJO` to install the git server
2. Proceed through `02-VAULTWARDEN` and `03-SYNCTHING`
3. Use `05-DISASTER-RECOVERY` for backups and verification
4. Document all infrastructure as you deploy

---

**Author:** ch1ch0 ([profile](https://github.com/ch1ch0-FOSS), [website](https://www.ch1ch0.me))


