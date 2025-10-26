# Fedora Asahi M1 Server Baseline \& Setup (v1.0)

_Audit-ready. FHS-aligned. Current as of 2025-10-25._

***

## 1. System Summary

- **Host:** Apple Silicon M1 (Mac Mini)
- **OS:** Fedora Linux Asahi Remix 42 – Kernel 6.16+
- **Hostname/IP:** Assigned statically for local network.
- **Main Storage:**
    - `/mnt/data` (primary SSD)
    - `/mnt/fastdata` (secondary SSD)
- **SELinux:** Enforcing

***

## 2. User Accounts and Privileges

| User | Home | Shell | Sudo | Purpose |
| :-- | :-- | :-- | :-- | :-- |
| admin | custom path | zsh | Yes | System administrator |
| ch1ch0 | custom path | bash | Yes | Daily use / portfolio |
| git | custom path | nologin | No | Git service account |
| forgejo | custom path | nologin | No | App/service data |
| nextcloud | custom path | nologin | No | App/service data |
| trading | custom path | zsh | No | Trading tools access |

_Only admin and ch1ch0 have sudo rights. All other users are for system services or app data only._

***

### Checkpoint 33 – GNOME \& KDE Multi-DE Integration (2025-10-25)

**Purpose:** Add and document dual desktop environments for multi-user administration and workflow demonstration.

**Artifacts:**

- Generic install script, troubleshooting documentation, changelog entry (see repo for public version).

**Key Lessons:**

- Some display managers incompatible with home directory symlinks.
- Alternatives selected to resolve login issues.
- Directory permissions updated for session startup.

***

## 3. Security and Access

- **SSH:** Key-based only (ed25519). Password login and root SSH disabled.
- **SELinux:** Always enforcing.
- **Firewall:** Zone “public”. Expose only necessary ports (SSH, HTTP, HTTPS).
- **Important Commands:**
Adjust firewall services and reload after changes.
Run SELinux relabel commands after modifying `.ssh` or key materials.

***

## 4. Filesystem Organization

- **Mountpoints:** `/mnt/data`, `/mnt/fastdata`
- **Directory Layout (FHS-aligned):**
    - `/mnt/data/srv/[app]`        – Service/app data
    - `/mnt/data/var/lib/[app]`    – Persistent state
    - `/mnt/data/var/log/[app]`    – Logs
    - `/mnt/data/etc/[app]`        – Configs
    - `/mnt/data/archive-old`      – Legacy/retired deployments

***

## 5. Checkpoint Timeline

| Stage | Summary |
| :-- | :-- |
| Install \& Network | OS install, static IP, SSH test |
| User / SSH / SELinux | User creation, sudo restriction, key auth |
| Security / Firewall | Enable firewall, restrict ports/services |
| System Update / Essentials | Update all, install core tools |
| Sudoers / Group Audit | Confirm admin and limited wheel/group access |
| Storage / Service Setup | Verify mounts, FHS layout, archive old data |
| Multi-DE Integration | Add and validate additional desktop options |


***

## 6. Service Deployments

### Forgejo

- Operates via systemd, uses MariaDB backend.
- Repositories and logs stored per FHS.
- Web UI available on assigned port.


### Nextcloud

- RPM, MariaDB, PHP, Redis, SELinux context applied.
- Data stored under designated FHS-aligned directories.
- Sync and access verified across GUI and web.

***

## 7. Automated Backup \& Restore

### 7.1 Automated Backup

- Unified backup script covers major services.
- Backups stored using timestamped directories by service.
- Database dumps included with each run.
- Scheduling via cron or systemd timer.
- Output logs to designated backup directory.
- Credential handling: No credentials in plaintext scripts/logs; managed via system secrets or vaults.
- Scripts and dump files: Strict permission enforced.


### 7.2 Restore Procedure

- Restore files and databases using `rsync` and database import commands.
- Recovery steps documented in restore guide.
- Conduct routine simulated restores with audit logging.


### 7.3 Retention \& Cleanup

- Regular review and deletion of outdated backup sets.
- Optional automated retention/prune scripts.


### 7.4 Admin Guidance

- Monitor and validate new backups, update documentation for changes.
- Extend backup/restore to new services before production.

***

## 8. Next Steps

- Complete backup/disaster recovery documentation.
- Verify backup rotation and retention.
- Continue periodic audits and group/sudo reviews.
- Document all future changes in the repository.

***

## 9. AI-COOP Integration (v2.0 Roadmap Segment)

Expanding platform for Human–AI collaborative system administration, workflow automation, and portfolio documentation.

**Focus Areas:**

- Code, automation, and AI modules documented/demonstrated in public repo.
- Separation of system, automation, and AI-coop content.
- Routine milestones and checkpoints for technical growth.


### Future Milestones

| Milestone | Target Date | Objective |
| :-- | :-- | :-- |
| DataSync Daemon | Nov 2025 | Automate service node sync across systems. |
| LLM Task Orchestration | Dec 2025 | Integrate local language models for docgen. |
| SysState Auditor | Jan 2026 | Automated audit agent for security/services. |
| Continuous Coop | Mar 2026 | Long-term AI + Human feedback/training loop. |


***

**AI-COOP Goal:**
Demonstrate technical and AI-assisted sysadmin workflows with visible, version-controlled documentation/artifacts.

***

Here is a **sanitized public version** of your `system-setup-v1.0.md`. All sensitive user-specific details, custom paths, and internal admin hints were removed or generalized, while keeping technical and architectural clarity for educational/public-facing purposes.

***

# Fedora Asahi M1 Server Baseline – Public Version (v1.0-public)

_Audit-ready. FHS-aligned. Current as of 2025-10-25._

***

## 1. System Summary

- **Hardware:** Apple Silicon M1 (Mac Mini)
- **OS:** Fedora Linux Asahi Remix 42 – Kernel 6.16+
- **Network:** Static LAN assignment
- **Storage:**
    - `/mnt/data` (primary SSD)
    - `/mnt/fastdata` (secondary SSD)
- **SELinux:** Enforcing

***

## 2. User Accounts and Privileges

| User | Home Directory | Shell | Sudo | Purpose |
| :-- | :-- | :-- | :-- | :-- |
| (admin) | Standard path | zsh | Yes | System administration |
| (user1) | Standard path | bash | Yes | Daily/portfolio use |
| (service) | Standard path | nologin | No | App/service accounts |

_Only primary sysadmin and one user account have sudo rights. Other users are for service isolation only._

***

### Multi-Desktop Environment Integration

**Purpose:** Enable and document multiple desktop environments (e.g., GNOME, KDE) for demonstration/multi-user flexibility.

**Artifacts:**

- Generic install scripts, troubleshooting notes, and changelog entries published as public examples.

**Key Lessons:**

- Some display managers may not support custom or complex home directory setups. Solutions documented in troubleshooting.

***

## 3. Security and Access

- **SSH:** Key-based authentication only. No password/root SSH logins.
- **SELinux:** Enforcing mode at all times.
- **Firewall:** Public zone, limited to required inbound ports (SSH, HTTP, HTTPS).
- **Note:** After firewall or SELinux changes, relabel/reload as per Fedora/SELinux best practices.

***

## 4. Filesystem Organization

- **Main Mountpoints:** `/mnt/data`, `/mnt/fastdata`
- **Directory Layout (FHS-aligned):**
    - `/mnt/data/srv/[app]`        – Application/service data
    - `/mnt/data/var/lib/[app]`    – App persistent state
    - `/mnt/data/var/log/[app]`    – App logs
    - `/mnt/data/etc/[app]`        – Application configs
    - `/mnt/data/archive-old`      – Archived/deprecated data

***

## 5. Provisioning Checklist \& Timeline

| Stage | Description |
| :-- | :-- |
| Install \& Network | Base OS setup, static IP config, SSH test |
| Account/Security | User creation, SSH keys, sudo lockdown |
| Firewall Setup | Configure zones and limit open ports |
| Base Updates | System updates, baseline tool install |
| Group/Sudo Audit | Review wheel/group, adjust as needed |
| Storage Verification | Confirm mountpoints, data structure |
| Multi-DE Demo | Add/verify GNOME, KDE, or other DEs |


***

## 6. Service Deployments

### Forgejo

- Self-hosted git server, MariaDB backend.
- Repositories/logs stored in service-aligned data directories.
- Web interface running on the configured port.


### Nextcloud

- Installed via RPM, uses MariaDB, PHP, and Redis.
- Data isolated under designated data directories, strict security context.
- Functionality verified via web and desktop clients.

***

## 7. Backup \& Restore Strategy

### Backups

- Scheduled scripted backups for all services and databases.
- Timestamped backup directories by service.
- Database dumps integrated per job run.
- Schedule handled by cron/systemd timer.
- No secrets in scripts/in logs; credentials handled securely.


### Restore

- Restoration of files/services using standard Fedora tools (`rsync`, database import).
- Steps documented generically without internal implementation specifics.
- Regular test restores recommended.


### Retention

- Outdated backup sets pruned as per compliance/policy.
- Retention periods adjustable for environment scale.

***

## 8. Improvement Roadmap – Public Segment

- Finalize/expand public documentation on backup practices and recovery workflows.
- Continue regular privilege audits and filesystem health checks.
- Publicly document major system upgrades and milestone events.

***

## 9. AI \& Automation Integration Preview

Intent to expand open-sourced platform for Human–AI collaborative sysadmin, automated documentation, and reproducible infrastructure best practices.

**Highlights:**

- Modular automation and documentation for rapid learning or demonstration.
- Future-proof separation of private/internal, and public/educational artifacts.

| Milestone | Projected Date | Public Objective |
| :-- | :-- | :-- |
| DataSync Service | Nov 2025 | Demonstrate cross-system sync |
| LLM Orchestration | Dec 2025 | Basic language model integration |
| State Auditing | Jan 2026 | Automated audit/playbook sample |
| Ongoing | Continuous | Feedback loops, system improvements |


***

**Goal:**
Provide transparent, reproducible system setup examples for the community, always sanitized to protect operational security and privacy.

***

