# 02-VAULTWARDEN

Encrypted password manager for credential storage.

## Overview

Self-hosted Vaultwarden instance. End-to-end encrypted password storage, automated backups, monthly recovery tests.

## Files

- `vaultwarden.env` - Configuration
- `backup-strategy.md` - Backup procedures
- `restore-test.log` - Proof of successful restore

## Quick Start

Start Vaultwarden

docker compose up -d
Access at https://localhost:8000
Or via Bitwarden clients (desktop/mobile)

text

## Security

- AES-256 encryption
- TLS/SSL for all connections
- Master password protection
- Automated encrypted backups

## Recovery

Tested monthly. Recovery time < 15 minutes.

See 05-DISASTER-RECOVERY for backup procedures.
