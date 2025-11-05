# 00-BOOTSTRAP

Build Fedora Asahi M1 from scratch, reproducibly.

## Overview

This directory contains the bootstrap procedure to build a minimal, hardened Fedora Asahi Linux system.

## Files

- `fedora-asahi-minimal-install.md` - Step-by-step installation
- `bootstrap.sh` - Automated setup script
- `packages.txt` - All packages installed

## Quick Reference

Read the installation guide first

cat fedora-asahi-minimal-install.md
Then run bootstrap

bash bootstrap.sh

text

## Expected Time

30-60 minutes for fresh install + configuration.

## Recovery from Scratch

After fresh Fedora install:
1. Run bootstrap.sh
2. All services auto-configured
3. Can rebuild entire system in under 2 hours

## See Also

- 01-FORGEJO for Git server setup
- 02-VAULTWARDEN for password manager
- 03-SYNCTHING for file sync
