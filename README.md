# srv-m1m-asahi: Fedora Asahi M1 Production Baseline

**Purpose:**  
This repository serves as both a professional public showcase of system administration and Linux infrastructure automation skills, and as a comprehensive fall-back for the solo admin (ch1ch0). It tracks all configuration, scripts, onboarding, and operational documentation for the Mac Mini (Apple Silicon M1) running Fedora Linux Asahi Remix.

**Technical baseline** 
Built on Fedora Asahi Remix: Server- the official Fedora flavor for Apple Silicon Macs. Kernel 6.1 + m1n1 boot chain, U-Boot, and GRUB providing native ARM64 support. 

## 📈 Operational Metrics
- Uptime: 99.98 % (tracked since July 2025)
- Automated backups: nightly ⏰ 3 AM systemd timer
- Restore tests: verified monthly
- Data footprint: 1.2 TB across Forgejo + Nextcloud
- Scripts automated: 10+


***

## Repo Structure

```
.
├── docs/         # Markdown docs: setup, AI handoff, restore, roadmap, system index, users, changelogs
│   ├── ai-handoff.md
│   ├── changelog/*.md
│   ├── restore.md
│   ├── roadmap-v1.0.md
│   ├── system-index.md
│   ├── system-setup-v1.0.md
│   └── users.md
├── scripts/      # Operational, automation, checkpoint, and backup scripts
│   ├── backup_all.sh
│   ├── backup_forgejo_dump.sh
│   ├── backup_nextcloud_forgejo.sh
│   ├── backup_nextcloud.sh
│   ├── fedora_bootstrap.sh
│   ├── install_forgejo.sh
│   ├── install_nextcloud.sh
│   ├── log_packages.sh
│   ├── setup_checkpoint_01-06.sh
│   └── setup_nextcloud.sh
├── skel.tpl/     # Shell/script skeleton templates for new automation tasks
│   └── shell-script-skel.TPL
├── tpl/          # Templates for docstrings and automated logging
│   ├── autolog-gen-sh.TPL
│   └── header-docstring-sh.TPL
├── README.md     # (This file)
├── .gitignore    # Hygiene rules for repo
```

***

## System Overview

- **Host:** Mac Mini (Apple Silicon M1), Fedora Linux Asahi Remix 42, kernel 6.16+
- **Primary storage:** `/mnt/data` (SSD, FHS-aligned)
- **Service stack:** Forgejo (git), Nextcloud (cloud/collab), plus future services for trading, 3D printing, automation/mining
- **Security:** SELinux enforcing, strict firewall, key-based SSH, two sudo-capable users
- **Metadata, user roles, SSH keys:** See `docs/system-setup-v1.0.md` & `docs/users.md`
- **Backup & recovery:** Fully automated, with docs/scripts tracking every step (`scripts/*`, `docs/restore.md`)

***

┌─────────────────────────────────────────────────────────┐
│                     Fedora Asahi Server (M1 Mac Mini)   │
│─────────────────────────────────────────────────────────│
│                Hardware Layer – Apple Silicon M1        │
│   • NVMe SSD (/mnt/data)   • CPU: 8‑core ARM64  • 16 GB RAM │
└──────────────┬──────────────────────────────────────────┘
               │
               ▼
┌──────────────────────────────┐
│      Fedora Asahi Remix 42   │
│  Kernel 6.16 + m1n1 Boot Chain│
│  SELinux • firewalld • systemd│
└──────────────┬────────────────┘
               │
               ▼
┌──────────────────────────────┐
│        Core Services         │
│  • Forgejo (Git Server)      │
│  • Nextcloud (Storage/Sync)  │
│  • Apache + PHP‑FPM (Web)    │
│  • MariaDB (Database)        │
└──────────────┬────────────────┘
               │a
               ▼
┌──────────────────────────────┐
│     Automation & Recovery Layer│
│  • rsync Backups (systemd timer 3 AM)│
│  • mysqldump Database Dumps   │
│  • Scripts in /srv-m1m-asahi/scripts│
│  • Docs: restore.md / ai‑handoff.md│
└──────────────┬────────────────┘
               │
               ▼
┌──────────────────────────────┐
│        Access & Security      │
│  • Key‑only SSH (logged per user)│
│  • Two sudo administrators    │
│  • Audit policies in users.md│
└──────────────────────────────┘

***

## Key Documentation

- **docs/system-setup-v1.0.md:**  
  Full baseline: devices, storage, users, security, FHS structure, deployment timeline, checkpoint verification, backup/restore summary

- **docs/ai-handoff.md:**  
  AI and admin handoff protocol. System state, backup plan, access policy, and operational standards for future handoff or disaster recovery. *All advice and changes must be reflected here*.

- **docs/restore.md:**  
  Step-by-step restore procedures for Nextcloud and Forgejo, with command references and audit notes.

- **docs/changelog/**:  
  Detailed, timestamped Markdown log of operational changes, upgrades, backups, security events, and major interventions.

- **docs/users.md:**  
  SSH user/key inventory for audit, with table of users, public keys, login policy, and admin/change notes.

- **docs/roadmap-v1.0.md:**  
  Project vision, contributions, upgrade/downtime tracking, and future buildout plans.

- **scripts/**:  
  All system-level and application onboarding scripts, backup automation, and checkpoint runners.  
  Scripts use robust logging and are tracked in source control for full repeatability.

- **skel.tpl/** and **tpl/**:  
  Shell script skeletons and logging/doc-string headers to support future onboarding and modular automation.

***

## Workflow and Best Practices

- **Change Control:**  
  Every system, admin, or AI change is tracked in Markdown in `docs/`, and in the corresponding bash script, then committed and pushed to Forgejo after each major session.

- **Audit & Recovery:**  
  All steps for service setup, backup, and restore are written for immediate use, audit readiness, and reproducibility.

- **World-Class Standards:**  
  SELinux and firewalld are always enabled. SSH is key-only. All storage is mounted/readied per FHS.  
  No change is "real" unless it's documented and committed.

***

## Private vs. Public Repos

- **srv-m1m-asahi:**  
  **Public-facing.** For professional portfolio, reproducibility, and disaster recovery for the solo admin.

- **admin (separate repo):**  
  Internal, not shared. For deeper world-class Linux admin scripts and historical/system microtasks.

***

## How To Use This Repo

1. **Read system-setup-v1.0.md and ai-handoff.md** for baseline and operational procedures.
2. **Follow restore.md** to recover from backups.
3. **Edit or add scripts and documentation** for every system change, onboarding, or new deployment.
4. **Commit and push** after every session—this repo is the canonical archive.

***

## Contact & Authorship

Primary admin: ch1ch0  
Direct all system queries or onboarding notes to docs/ai-handoff.md before change.

***

## 🧭 For Reviewers / Hiring Managers
This repository demonstrates:
- End‑to‑end Linux server deployment on non‑standard hardware (Apple M1)
- System automation, documentation discipline, and audit‑ready operation
- Adherence to enterprise standards: SELinux enforcing, key‑only SSH, FHS compliance

***
