last update: 10/6/2025

“This document is gospel for my system. Any advice, config, or install must comply with it—and update it after each action.”


# AI Sysadmin Handoff – Local Foundation (Fedora Asahi M1 Mac Mini)

_Audit-ready, FHS-aligned, self-hosted production baseline – Last update: 2025-10-06_

***

## 1. System State

- **Host:** srv-m1m-asahi (Apple Silicon M1 Mac Mini)
- **OS:** Fedora Linux Asahi Remix 42 (Kernel 6.16+)
- **Main Storage:** `/mnt/data` (SSD, FHS compliant)
- **Major Services:** Forgejo (version control), Nextcloud (cloud), Trading/Ai, Canaan, Bambulabs (separate users)
- **GUI Ops:** GUI stack (XFCE) for user-specific apps as needed, otherwise headless/terminal
- **Security:** SELinux enforcing; firewalld active; only 22/80/443 open

***

## 2. Backup & Disaster Recovery

- **File Backups:** Nightly rsync snapshot of `/mnt/data` to `/mnt/fastdata`
- **DB Dumps:** Nightly mysqldump for Forgejo/Nextcloud
- **Service Data:** All key users (`admin`, `trading`, `canaan`, `bambulabs`) have data homes symlinked to `/mnt/data`, all included in backup
- **Scripts:** Located in `/mnt/data/scripts/`; see `/mnt/data/docs/restore.md` for full-recovery steps
- **Health/Audit:** Monthly restore tests, disk audits, and backup log checks

***

## 3. Access Control

- **SSH:** Key-based (`ed25519`) only, root and password logins disabled
- **Sudo/Wheel:** Only `admin` and `ch1ch0` in wheel group; no legacy/demo/test users remain
- **User Organization:** Each service/income stream—trading, mining, printing, etc.—runs under its own user for strict isolation
- **Key Management:** All public keys documented in `/mnt/data/docs/users.md`

***

## 4. Filesystem & Service Structure

- **Strict FHS layout:** All service data under `/mnt/data` (e.g., `/mnt/data/srv/trading`, `/mnt/data/var/lib/nextcloud`)
- **Home symlinks:** `/home/[user] -> /mnt/data/[user]` for all active users
- **Archive:** `/mnt/data/archive-old` for retired configs, obsolete data
- **Source Control:** All scripts, major configs are tracked in Forgejo (git@this-host:git/...)

***

## 5. Documentation & Audit

- **Baseline:** `/mnt/data/docs/system-setup-v1.0.md` (all configs, decisions, backup/restore, users)
- **Changelog:** `/mnt/data/logs/changelog.md` (all system changes, service deployments, upgrades)
- **Onboarding:** `/mnt/data/docs/onboarding.md` (user/admin handoff, new service deployments)
- **Handoff:** This doc serves as a live protocol for handoff to future admins/AI
- **Best Practices:** Every major step/checkpoint gets a Markdown doc + corresponding `.sh` script
- **Version Control:** Document changes and post to Forgejo *immediately* after each session/upgrade/incident

***

## 6. Foundation Completion Steps

- Finalize and document backup/restore for *every* user/service
- Add full onboarding/readme for each service user (esp. trading, canaan, bambulabs)
- Install and configure XFCE GUI *per user* only for GUI-dependent tools (e.g., OpenBB)
- Document all new workflows, virtualenvs, GUI access requirements
- Test backups, permission boundaries, and SELinux in monthly audits
- Evaluate and update Forgejo repo as latest source of all scripts/docs/configs

***

## 7. Roadmap & Ongoing Actions

- Build and document each new user/service environment—checkpoint in both `.md` and `.sh`
- Audit sudoers, SSH keys, and user lists after any significant change
- Automate backup verification and prune/rotate old backups
- Keep all service and buildout documentation in version control (Forgejo), and reference latest commit hashes in docs for full traceability

***

**Action Reminder:**  
After every major config, buildout, or backup script edit, `git add/commit/push` to Forgejo—keep this doc and your `.md` checkpoints as your *system’s canonical history*. Any critical change not in git is not considered “real.”  
This is your system's foundation for professional, auditable, and AI-ready operations[1][2].

