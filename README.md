# srv-m1m-asahi

> Fedora Asahi Remix server infrastructure on Apple Silicon M1 Mac Mini

[![Fedora](https://img.shields.io/badge/Fedora-Asahi_Remix_42-51A2DA)](https://asahilinux.org/)
[![Apple Silicon](https://img.shields.io/badge/Apple-M1-999999)](https://support.apple.com/en-us/HT211814)
[![Shell](https://img.shields.io/badge/Shell-Bash%2FZsh-green)](https://www.gnu.org/software/bash/)

## Overview

Production-ready Linux server infrastructure running on Apple Silicon. Demonstrates systems administration automation, security hardening, vim-toolkit workflow, and self-hosted service deployment (Forgejo, Nextcloud, trading tools).

**System:** Fedora Asahi Remix 42, Kernel 6.16+, SELinux enforcing, SSH key-only

## Architecture

### Infrastructure Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **OS** | Fedora Asahi Remix 42 | ARM64 Linux for Apple Silicon |
| **Window Manager** | Sway (Wayland) | Keyboard-first, vim-aligned compositor |
| **Version Control** | Forgejo (self-hosted) | Local-first Git platform |
| **Cloud Suite** | Nextcloud | File sync, collaboration |
| **Database** | MariaDB | Backend for services |
| **Firewall** | firewalld | Network security |
| **SELinux** | Enforcing | Mandatory access control |

### User Roles

| User | Shell | Sudo | Purpose |
|------|-------|------|---------|
| `sysadmin` | zsh | Yes | System administration (vim-toolkit) |
| `ch1ch0` | bash | Yes | Daily use, portfolio development (GUI) |
| `trading` | zsh | No | Trading tools, OpenBB, ollama (GUI) |
| `forgejo` | nologin | No | Git service daemon |
| `nextcloud` | nologin | No | Cloud service daemon |

## Features

**Security Hardening:**
- SELinux enforcing mode
- SSH key-only authentication (ed25519)
- firewalld with minimal attack surface
- Automated backup rotation

**Vim-Universal Toolkit (sysadmin):**
- **nvim** - Text editing, config management
- **vifm** - File manager (vim keybinds)
- **vimb** - Web browser (vim keybinds)
- **tmux** - Terminal multiplexer
- **foot** - Wayland terminal
- **rofi** - Application launcher
- **Sway** - Window manager (keyboard-first)

**Services:**
- Forgejo (port 2222 SSH, 3000 HTTP) - Self-hosted Git
- Nextcloud - File sync and collaboration
- ollama - LLM service for trading user

## Directory Structure

/mnt/data/
├── srv/ # Service data (Forgejo, Nextcloud)
├── var/lib/ # Persistent state
├── var/log/ # Application logs
├── etc/ # Service configs
├── backups/ # Automated daily backups
├── sysadmin/ # Admin toolkit, docs, scripts
├── ch1ch0/ # Portfolio development
└── trading/ # Trading tools, OpenBB


## Getting Started

### Prerequisites

- Apple Silicon M1 Mac Mini
- Fedora Asahi Remix installation media
- SSH key pair for authentication

### Installation Scripts

All checkpoint scripts are reproducible and documented:

Fedora bootstrap
./scripts/fedora_bootstrap.sh

Checkpoint installations (sequential)
./scripts/setup_checkpoint_01.sh # Base system
./scripts/setup_checkpoint_02.sh # Users and security
./scripts/setup_checkpoint_03.sh # Forgejo
./scripts/setup_checkpoint_04.sh # Nextcloud
./scripts/setup_checkpoint_05.sh # Sway + vim-toolkit
./scripts/setup_checkpoint_06.sh # Trading environment

### Key Configuration Files

- `/docs/system-setup.md` - Complete system baseline (v1.1.1)
- `/docs/runbook.md` - Operational procedures
- `/docs/00.system-index.md` - Directory structure reference
- `~/.config/sway/config` - Sway window manager config
- `/changelog/` - All system changes and checkpoints

## Documentation

| Document | Purpose |
|----------|---------|
| `system-setup.md` | Current system baseline and checkpoint history |
| `runbook.md` | Daily operations, recovery procedures |
| `00.system-index.md` | Directory structure mapping |
| `security-hardening.md` | SELinux, firewall, SSH hardening |
| `troubleshooting/` | Common issues and resolutions |
| `changelog/` | Dated system change logs |

## Version Control Workflow

**Local-First Philosophy:**
Primary: Forgejo (local source of truth)
git push origin main

Mirror: GitHub (public portfolio)
git push github main


All repositories use Forgejo built-in SSH (port 2222) for authentication.

## Backups

Automated daily backups to `/mnt/data/backups/`:

Verify latest backup
ls -lah /mnt/data/backups/ | tail -5

Manual backup
sudo rsync -av /mnt/data/ /mnt/fastdata/backup-$(date +%Y%m%d)/


## Checkpoint Timeline

| Checkpoint | Date | Description |
|------------|------|-------------|
| CP33 | 2025-10-25 | GNOME & KDE multi-DE integration |
| CP34 | 2025-10-26 | Local-first Git with Forgejo |
| CP35 | 2025-10-27 | Sway Wayland compositor |
| CP36 | 2025-10-27 | wlogout session management |
| CP37 | 2025-10-28 | Vim-universal keybind finalization |
| CP38 | 2025-10-30 | System audit & vim-toolkit consolidation |
| CP39 | 2025-10-30 | Portfolio site deployment |

Full checkpoint history in `/changelog/` and `system-setup.md`.

## Security

- **SSH:** Key-based only (ed25519), root login disabled
- **SELinux:** Always enforcing
- **Firewall:** Minimal ports (22, 80, 443, 2222)
- **Backups:** Daily automated, tested monthly

## Contributing

This is a personal infrastructure project. Issues and suggestions welcome via GitHub Issues. Public documentation provided for portfolio demonstration.

## License

Documentation: CC BY 4.0  
Scripts: MIT License

---

**Maintained by:** sysadmin  
**System Version:** v1.1.1  
**Last Updated:** 2025-10-30  
**System:** Fedora Asahi Remix 42, Apple Silicon M1



