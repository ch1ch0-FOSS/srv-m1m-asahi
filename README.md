# srv-m1m-asahi

**Enterprise-Grade Fedora Asahi Infrastructure – Built from Scratch**

A production-ready, self-hosted Linux server demonstrating system architecture, automation, and operational discipline on Apple Silicon hardware. This repository serves as a living portfolio of system administration expertise and infrastructure-as-code practices.

---

## 🖥️ System Overview

**Hardware:** Apple Mac mini (M1, 2020)  
**OS:** Fedora Linux Asahi Remix 42 (Kernel 6.16.8)  
**Architecture:** aarch64 (Apple Silicon)  
**Uptime Philosophy:** Production-stable, security-hardened, audit-ready

### Key Characteristics
- **SELinux:** Enforcing mode for mandatory access control
- **Firewall:** Active firewalld with minimal attack surface
- **Storage Strategy:** Data-device separation via FHS-compliant external SSD mounts
- **Service Isolation:** Dedicated system users per workload (sysadmin, trading, ch1ch0)
- **Backup Regime:** Automated nightly snapshots with systemd timers

---

## 📂 Directory Structure

srv-m1m-asahi/
├── ai-coop/ # Human-AI collaboration workflows and checkpoints
├── automation/ # Backup scripts, monitoring, orchestration
├── changelog/ # Version-controlled system change log
├── docs/ # Public-facing documentation and guides
├── scripts/ # Infrastructure-as-code setup and deployment scripts
└── users/ # User-specific configs and portfolio artifacts


### Storage Architecture (FHS-Aligned)

**Primary Mount:** `/mnt/data` (7.28 TiB SSD)  
**Backup Mount:** `/mnt/fastdata` (1.82 TiB SSD)

All user homes symlinked to `/mnt/data/[username]` for data persistence and backup efficiency:
- `/home/sysadmin → /mnt/data/sysadmin`
- `/home/ch1ch0 → /mnt/data/ch1ch0`
- `/home/trading → /mnt/data/trading`

Service data lives under `/mnt/data/srv/` and `/mnt/data/var/lib/`:
- Forgejo (git server)
- Nextcloud (file sync and collaboration)
- Trading stack (OpenBB, Ollama LLMs, IBKR/ThinkorSwim integration)

---

## 🛠️ Core Services

| Service | Purpose | Status |
|---------|---------|--------|
| **Forgejo** | Self-hosted Git server with GitHub mirroring | Operational |
| **Nextcloud** | Private cloud storage and file sync | Operational |
| **Trading Stack** | Algorithmic trading infrastructure (OpenBB + Ollama) | In Development |
| **Mastodon** | Federated social media instance | Planned |
| **Matrix**  |                                  | Planned | 
---

## 👥 User Profiles

### sysadmin
**Role:** Infrastructure architect and sole administrator  
**Scope:** System buildout, security hardening, automation development  
**Environment:** Sway (Wayland tiling WM) for minimal overhead and keyboard-driven workflow

### ch1ch0
**Role:** Daily workstation and multi-environment demonstration  
**Scope:** GNOME and KDE Plasma showcase, portfolio development, web presence  
**Purpose:** Proof of desktop environment administration and user experience design

### trading
**Role:** Enterprise trading operations  
**Scope:** Stock and options analysis using OpenBB, Ollama-powered LLMs, broker integrations  
**Purpose:** Building a professional-grade algorithmic trading company from the ground up

---

## 🔒 Security & Access Control

- **SSH Authentication:** Key-based only (ed25519), password auth disabled
- **Sudo Access:** Restricted to `sysadmin` and `ch1ch0` via wheel group
- **SELinux:** Enforcing mode for defense-in-depth
- **Firewall:** firewalld with default-deny posture
- **Mobile Admin:** Pixel Fold with GrapheneOS configured as secure remote admin terminal

---

## 💾 Backup & Disaster Recovery

**Strategy:** Automated nightly backups via systemd timers and rsync

**Coverage:**
- All user home directories (`/mnt/data/{sysadmin,ch1ch0,trading}`)
- Service data (Forgejo repositories, Nextcloud files)
- Database dumps (MariaDB for Forgejo/Nextcloud)

**Backup Location:** `/mnt/fastdata/backups/` with timestamp-based retention  
**Testing:** Monthly restore drills documented in private sysadmin logs

---

## 🤖 Automation & Infrastructure-as-Code

All system configuration is scripted for repeatability and auditability:

### Key Scripts
- `fedora_bootstrap.sh` – Initial system hardening and package baseline
- `setup_checkpoint_*.sh` – Incremental infrastructure buildout stages
- `install_forgejo.sh` – Git server deployment
- `install_nextcloud.sh` – Cloud storage setup
- `setup_trading_user_openbb_ollama.sh` – Trading environment provisioning

### Naming Convention
- Standard files: `lowercase-with-hyphens.md`
- Executable scripts: `lowercase_with_underscores.sh`
- Acronyms: `ALL-CAPS` for semantic clarity (e.g., `FHS`, `SSH`)

---

## 📚 Documentation Protocol

**Canonical Source:** Private Forgejo repository at `/mnt/data/sysadmin`  
**Public Mirror:** This GitHub repository (sanitized for security)

All major changes are:
1. Implemented via version-controlled scripts
2. Logged in `/mnt/data/sysadmin/changelog/`
3. Sanitized and published to public GitHub mirror
4. Tagged with ISO 8601 timestamps for audit trail

---

## 🎯 Portfolio Intent

This repository demonstrates:
- **System Architecture:** FHS compliance, storage planning, service isolation
- **Automation Discipline:** Infrastructure-as-code with shell scripting
- **Security Engineering:** SELinux, firewalld, key-based auth, principle of least privilege
- **Operational Maturity:** Backup/restore procedures, change management, documentation rigor
- **Platform Expertise:** Fedora Asahi on Apple Silicon (cutting-edge hardware support)

**Target Audience:** Hiring managers, DevOps/SRE teams, infrastructure engineers

**Live Demonstration:** [ch1ch0.me](https://ch1ch0.me) (personal domain showcasing integrated portfolio)

---

## 🚀 Skills Showcase

- Linux system administration (Fedora, SELinux, systemd)
- Shell scripting and automation (Bash, infrastructure-as-code)
- Storage architecture (btrfs, FHS, data-device separation)
- Service deployment (Forgejo, Nextcloud, containerization prep)
- Security hardening (SSH, firewall, access control)
- Version control (Git, Forgejo self-hosting, GitHub mirroring)
- Documentation and change management
- Apple Silicon Linux (Asahi Remix expertise)

---

## 🔗 Repository Context

**Public Repository:** `github.com/ch1ch0-FOSS/srv-m1m-asahi`  
**Private Source:** Local Forgejo instance (credentials not disclosed)  
**Mirroring:** Automated push to GitHub for portfolio visibility

**Sanitization Policy:**
- No credentials, API keys, or private IP details
- Redacted personal information (government name, sensitive logs)
- Public-safe scripts and documentation only

---

## 📧 Contact

**Professional Inquiries:** Via [ch1ch0.me](https://ch1ch0.me) contact form  
**GitHub Profile:** [github.com/ch1ch0-FOSS](https://github.com/ch1ch0-FOSS)

---

## 📜 License

Documentation and scripts provided as-is for portfolio demonstration.  
Adapt freely for learning; attribution appreciated.

---

**Last Updated:** 2025-25-26  
**System Status:** Production-ready, actively maintained


