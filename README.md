# srv-m1m-asahi

**Proof of Practice:** Complete Fedora Asahi M1 infrastructure deployment, maintenance, and disaster recovery.

This is my actual running server. It demonstrates how I bootstrap infrastructure, deploy services, maintain backups, and recover from failure.

## Quick Start

See the numbered directories in order to understand the full deployment:

1. **00-BOOTSTRAP** - Build Fedora Asahi from scratch
2. **01-FORGEJO** - Self-hosted Git server
3. **02-VAULTWARDEN** - Encrypted password management
4. **03-SYNCTHING** - File synchronization
5. **04-INFRASTRUCTURE** - Monitoring and health checks
6. **05-DISASTER-RECOVERY** - Backup and recovery procedures

## My Infrastructure Philosophy

- **Reproducible** - Build from scratch in under 2 hours
- **Documented** - Step-by-step deployment guides
- **Tested** - Disaster recovery tested monthly
- **Minimal** - Only essential tools installed
- **Secure** - Hardened configs, encrypted storage, automated backups

## Getting Started

Each numbered directory (00-05) contains:
- README.md with overview
- Implementation files (scripts, configs, documentation)
- Backup/restore procedures

Start with 00-BOOTSTRAP to understand the full setup.

## Key Files

- `TROUBLESHOOTING.md` - Common issues and solutions
- `packages.txt` - All installed packages
- Each directory has its own README.md

## For Hiring Managers

Check 05-DISASTER-RECOVERY first—that's where operational discipline matters most.
