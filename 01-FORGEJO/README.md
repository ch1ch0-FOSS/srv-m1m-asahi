# 01-FORGEJO

**Self-Hosted Git Server – Fedora Asahi M1**

Forgejo provides private, secure, on-premises version control for all infrastructure code, automation scripts, and project repositories. This deployment is production-ready, includes automated backups, and mirrors to GitHub for public visibility.

---

## Purpose

- **Local-first version control**: All code lives on-prem first, not vendor-dependent.
- **Reproducible deployment**: Single script installs binary, creates system user, and configures systemd service.
- **Backup & disaster recovery**: Daily automated backups tested monthly (see [backup-strategy.md](./backup-strategy.md)).
- **GitHub mirroring**: Pushes to Forgejo auto-sync to GitHub for public portfolio presence.

---

## Files

- **`install_forgejo.sh`**: Automated installation script (ARM64 binary, systemd service, user/permissions).
- **`backup-strategy.md`**: Backup schedule, retention policy, and restore procedure.
- **`restore-test.log`**: Evidence of successful disaster recovery tests.
- **`forgejo-config-example.ini`**: Sample app.ini configuration (sanitized for reference).
- **`troubleshooting.md`**: Common issues and how to resolve.

---

## Prerequisites

- Fedora Asahi (or similar Linux) with:
  - MariaDB (or PostgreSQL) running and accessible
  - Git and Git LFS installed
  - Network access to pull Forgejo binary
- Run `00-BOOTSTRAP` first to ensure system hardening and required packages.

---

## Installation

**1. Run the install script as root or with sudo:**

sudo bash install_forgejo.sh


**2. Complete web setup:**
- Navigate to `http://YOUR_SERVER_IP:3000`
- Configure database connection, admin user, and repository root.
- Follow on-screen prompts.

**3. Verify service:**

sudo systemctl status forgejo


---

## Configuration

- Config file: `/etc/forgejo/app.ini`
- Data directory: `/var/lib/forgejo`
- Repositories: `/var/lib/forgejo/data/forgejo-repositories`
- Logs: `/var/lib/forgejo/data/log`

See [`forgejo-config-example.ini`](./forgejo-config-example.ini) for annotated examples.

---

## Backup & Recovery

- **Automated backups**: Daily snapshots of repositories and database.
- **Tested monthly**: Recovery procedures validated and logged (see `restore-test.log`).
- **Strategy details**: [backup-strategy.md](./backup-strategy.md)

---

## GitHub Mirroring

- Each repository in Forgejo can push-mirror to GitHub automatically.
- Configured per-repo in Forgejo Settings → Repository → Mirroring.
- Allows public portfolio visibility while maintaining local-first workflow.

---

## Troubleshooting

- Service won't start? Check logs: `journalctl -u forgejo -f`
- Permission errors? Verify `/var/lib/forgejo` owned by `git:git`.
- Database connection failed? Ensure MariaDB is running and credentials in `app.ini` match.

See [troubleshooting.md](./troubleshooting.md) for detailed fixes.

---

## Next Steps

- Set up SSH keys for git operations (see `02-VAULTWARDEN` for key management).
- Configure repository mirroring to GitHub.
- Integrate with CI/CD or automation pipelines (optional).
- Move to `03-SYNCTHING` for file synchronization across devices.

---

**Maintained by:** ch1ch0 ([profile](https://github.com/ch1ch0-FOSS), [website](https://www.ch1ch0.me))

