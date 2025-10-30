# srv-m1m-asahi: Fedora Asahi Linux Server Setup

**Platform:** Apple Silicon M1 Mac Mini  
**OS:** Fedora Linux Asahi Remix 42  
**Purpose:** Professional Linux system administration portfolio showcasing enterprise-grade server setup, automation, and multi-user environment configuration.

---

## Overview

This repository documents a complete, production-ready Fedora Asahi Linux server build on Apple Silicon hardware. It demonstrates professional system administration practices including FHS compliance, security hardening, service orchestration, automated backups, and keyboard-centric workflow optimization.

**Key Highlights:**
- SELinux enforcing mode with hardened security configuration
- Multi-user environment (sysadmin, developer, trader roles)
- Self-hosted services: Forgejo (Git), Nextcloud (files), Ollama (AI/LLM)
- Sway Wayland compositor with vim-universal keybindings
- Fully automated installation and checkpoint scripts
- Comprehensive documentation and troubleshooting guides

---

## Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/srv-m1m-asahi.git
cd srv-m1m-asahi

# Review documentation
cat docs/system-setup.md
cat docs/system-index.md

# Run bootstrap (for fresh Fedora Asahi installation)
chmod +x scripts/install/fedora_bootstrap.sh
sudo ./scripts/install/fedora_bootstrap.sh

# Run checkpoint installations in sequence
chmod +x scripts/setup/setup_checkpoint_*.sh
sudo ./scripts/setup/setup_checkpoint_01.sh
# ... continue with remaining checkpoints
```

---

## Repository Structure

| Directory | Description |
|-----------|-------------|
| **docs/** | Complete system documentation, guides, and wiki |
| **scripts/** | Installation, setup, and automation scripts |
| **scripts/install/** | Individual service installers (Forgejo, Nextcloud, etc.) |
| **scripts/setup/** | Sequential checkpoint scripts for reproducible builds |
| **scripts/automation/** | Backup and monitoring automation |
| **scripts/templates/** | Reusable script templates and documentation skeletons |
| **examples/** | Configuration examples and system screenshots |
| **changelog/** | Chronological change history and audit trail |

---

## System Specifications

- **Hardware:** Apple Mac Mini (M1, 2020)
- **CPU:** Apple M1 (8 cores) @ 2.99 GHz
- **GPU:** Apple M1 (8 cores, integrated)
- **Memory:** 16 GB
- **Storage:** 
  - Root: 162.70 GB (btrfs)
  - Data mount: 7.28 TB (btrfs)
  - Fast data: 1.82 TB (btrfs)
- **Kernel:** Linux 6.16.8-400.asahi.fc42.aarch64+16k
- **Display Server:** Wayland (Sway 1.10.1)
- **Security:** SELinux Enforcing

---

## Features

### Services & Applications
- **Forgejo:** Self-hosted Git server (port 3000, SSH 2222)
- **Nextcloud:** Personal cloud storage and file sync
- **MariaDB:** Database backend for services
- **Ollama:** Local LLM for AI-assisted system administration
- **OpenBB:** Financial market data and trading analysis

### Desktop Environment
- **Sway:** Tiling Wayland compositor with vim-universal keybindings
- **Terminal:** foot (Wayland-native)
- **Editor:** Neovim with extensive configuration
- **File Manager:** vifm (vim-like file manager)
- **Browser:** vimb (vim-like browser), LibreWolf (fallback)
- **Application Launcher:** rofi (Wayland mode)

### User Environments
- **sysadmin:** System administration with keyboard-centric workflow
- **ch1ch0:** Development and portfolio work
- **trading:** Market analysis and trading tools

---

## Documentation

| Document | Description |
|----------|-------------|
| [System Setup](docs/system-setup.md) | Complete installation and configuration guide |
| [System Index](docs/system-index.md) | Master reference for all files and services |
| [Troubleshooting](docs/troubleshooting/) | Common issues and solutions |
| [Wiki](docs/wiki/) | In-depth guides for specific services |

---

## Automation

### Installation Scripts
All services can be installed via automated scripts in `scripts/install/`:
- `fedora_bootstrap.sh` - Initial system setup
- `install_forgejo.sh` - Git server setup
- `install_nextcloud.sh` - Cloud storage setup
- `install_librewolf.sh` - Privacy-focused browser
- Additional service installers

### Checkpoint System
Reproducible builds via sequential checkpoints in `scripts/setup/`:
- `setup_checkpoint_01.sh` through `setup_checkpoint_06.sh`
- Each checkpoint is idempotent and documented
- Enables version-controlled infrastructure as code

### Backup Automation
Automated backup scripts in `scripts/automation/backup/`:
- `backup_all.sh` - Complete system backup
- `backup_forgejo_dump.sh` - Git server backup
- `backup_nextcloud.sh` - Cloud storage backup
- Configured for scheduled execution via systemd timers

---

## Security & Compliance

- **SELinux:** Enforcing mode with custom policies
- **Firewall:** firewalld with restrictive rules
- **SSH:** Key-based authentication only, non-standard ports
- **User Isolation:** Separate accounts with least-privilege access
- **Audit Trail:** Comprehensive changelog and log retention
- **Backup:** Nightly automated backups to dedicated storage

---

## Screenshots

Visual demonstrations of the system can be found in `examples/screenshots/`:
- Sway desktop environment
- Multi-user configurations
- Service dashboards
- Terminal workflows

---

## Professional Use Cases

This repository demonstrates skills applicable to:
- **DevOps/SRE:** Infrastructure as code, automation, monitoring
- **Linux System Administration:** Multi-user management, service orchestration
- **Security Engineering:** Hardening, compliance, audit trails
- **Technical Documentation:** Comprehensive guides and runbooks
- **Self-Hosted Infrastructure:** Privacy-focused alternative to cloud services

---

## Technologies Used

**Operating System:** Fedora Asahi Remix 42, Linux 6.16+  
**Display Server:** Wayland (Sway compositor)  
**Version Control:** Git (Forgejo self-hosted)  
**Databases:** MariaDB  
**Programming/Scripting:** Bash, Python  
**Containers:** Docker-ready (Podman support)  
**Web Servers:** Nginx, PHP-FPM  
**AI/ML:** Ollama (local LLM inference)  
**Security:** SELinux, firewalld, SSH hardening  

---

## Contributing

This is a personal portfolio project, but suggestions and feedback are welcome via issues.

---

## License

Documentation and scripts: MIT License  
Configuration examples: Public Domain (CC0)

---

## Contact

For questions about this setup or professional inquiries, see contact information in repository profile.

---

## Acknowledgments

- Asahi Linux team for Apple Silicon support
- Fedora Project for excellent ARM64 support
- Open source community for all the amazing tools

---

*This repository showcases professional Linux system administration capabilities including automation, security, documentation, and infrastructure management suitable for DevOps, SRE, and system administrator roles.*
