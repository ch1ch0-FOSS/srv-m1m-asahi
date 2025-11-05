# 01-FORGEJO

Self-hosted Git server for version control.

## Overview

Forgejo deployment on Fedora Asahi M1. Handles version control, mirrors to GitHub, maintains automated backups.

## Files

- `docker-compose.yml` - Forgejo service definition
- `backup-strategy.md` - How backups work
- `restore-test.log` - Proof of successful restore

## Quick Start

docker compose up -d
Access at http://localhost:3000

text

## Backup & Recovery

Backups run daily. Recovery tested monthly.

See `backup-strategy.md` for details.

## Integration

- Mirrors to GitHub automatically
- Syncs with local Vaultwarden for SSH keys
- See 05-DISASTER-RECOVERY for full backup procedure
