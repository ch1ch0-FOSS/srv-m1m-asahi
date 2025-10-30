<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# here is the system roadmap to sanitize

# Fedora Asahi Server: AI Handoff \& Buildout Plan

## Project Vision

This project aims to create a world-class, reproducible, and secure Fedora/Asahi Linux server setup—from bare metal to production application hosting (Nextcloud, Forgejo)—with all steps fully documented and scripted for future use, training, and disaster recovery.

***

## Handoff Instructions (For Human or AI Collaborator)

- **Goal:** At each main checkpoint, generate or expand:
    - A Markdown documentation file (`SYSTEM_SETUP.md` or wiki page) with: system state, configs, actions, and reasons.
    - A corresponding shell script (`setup_checkpoint_<n>.sh`) with only the commands for that step.
- **Checkpoints:** Every major change (user, network, security, package, or app install) is a checkpoint.
- **AI-assistants should:** Ask clarifying questions if intent or config is ambiguous, and always summarize new changes at each checkpoint in both `.md` and `.sh` form.

***

## Project Outline and Checkpoints

### 1. Initial System Install \& Access ([DONE])

- Install Fedora/Asahi, set up networking, first login.
- Document image versions, device identifiers, and initial accounts.


### 2. User \& SSH Setup ([DONE])

- Create admin and user accounts, assign shells.
- Harden SSH, deploy and test keys, check permissions and SELinux.
- **Artifacts:** SYSTEM_SETUP.md (users, shells, SSH), setup_checkpoint_01.sh


### 3. Firewall \& Security ([DONE])

- Enable and configure firewalld; restrict to SSH/HTTP/HTTPS only.
- Set SELinux to enforcing.
- Test and log firewall status/settings.
- **Artifacts:** SYSTEM_SETUP.md (firewalld, SELinux), setup_checkpoint_02.sh


### 4. System Update \& Essential Tools ([DONE])

- Full system update.
- Install core utilities (dnf, htop, ncdu, etc).
- Document current package list for reproducibility.


### 5. Sudo/Privilege \& Groups ([DONE])

- Configure/administer sudoers.
- Review and document all user privileges and group assignments.


### 6. Application Prep  ([DONE])

- Prepare storage and directories using FHS.
- Plan/record data locations for Nextcloud, Forgejo, etc.


### 7. Application Deployment [IN PROGRESS]

- Nextcloud: [DONE]
- Forgejo: [DONE]
- Trading Environment (OpenBB, Ollama): [DONE]
- GNOME/KDE Multi-DE: [DONE] — Checkpoint 33
- AI-Coop Job Tracker: [DONE] — Checkpoint 34


### 8. Ongoing Maintenance \& Backup Strategy [DONE]

- Automated nightly backups: [DONE]
- Systemd timers: [DONE]
- Monthly restore tests: [IN PROGRESS]

***

## Working Template (For Each Checkpoint)

### system-setup.md

```markdown
## Checkpoint X: <Short Title, Date>
**Description:**  
<Briefly document goal, what was accomplished, and how. Name scripts produced.>

**Relevant Commands/Config:**
\`\`\`bash
<copy-paste each command run or needed for this step>
\`\`\`

**Verification/Outcome:**
- <What should be true after this checkpoint?>
- <How to check it (commands/file outputs)?>
```


### setup_checkpoint_X.sh

```bash
#!/bin/bash
# Checkpoint X: <Short Title, Date>
# <Short description>

# Commands begin:
<commands from this step, in order, with comments if needed>
```

Citations:
[1] selected_image_6007554436595579861.jpg [https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/images/81945704/a200289d-a68d-4035-b642-a4f95b42f094/selected_image_6007554436595579861.jpg](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/images/81945704/a200289d-a68d-4035-b642-a4f95b42f094/selected_image_6007554436595579861.jpg)

Perfect — the content of your `roadmap‑v1.0.md` is solid and well structured, but it can be cleaned slightly for professional readability, GitHub rendering compliance, and consistent Markdown hierarchy.

Here is your file **ready to paste directly** into the `srv‑m1m‑asahi/docs/roadmap‑v1.0.md` location.

***

# Fedora Asahi Server: AI Handoff \& Buildout Plan

## Project Vision

Establish a world‑class, reproducible, and secure Fedora Asahi Linux server environment—from bare metal to production application hosting—fully documented and scripted for training, recovery, and portfolio demonstration.
Primary hosted services include Nextcloud (cloud suite) and Forgejo (version control) within a headless or GUI‑capable infrastructure (GNOME, KDE, Sway).

***

## Handoff Instructions (for Human or AI Collaborator)

- **Goal:**
At each major checkpoint, create or update:
    - A Markdown documentation file (`SYSTEM_SETUP.md` or wiki page) describing current system state, configurations, changes, and rationale.
    - A companion shell script (`setup_checkpoint_<n>.sh`) reproducing the commands for that step exactly.
- **Checkpoint definition:** Any significant configuration (user, network, security, package, app install, or automation change).
- **AI assistants must:**
    - Clarify ambiguous instructions before execution.
    - Summarize every modification in both `.md` and `.sh` formats.

***

## Project Outline \& Checkpoints

\#\#\# 1 — Initial System Install \& Access  ✅

- Install Fedora Asahi.
- Configure networking and first login.
- Document image version, device ID, and initial accounts.

\#\#\# 2 — User \& SSH Setup  ✅

- Create `admin` and `ch1ch0` accounts; assign shells.
- Harden SSH (key‑only), verify SELinux contexts.
- **Artifacts:** `SYSTEM_SETUP.md` (users, SSH), `setup_checkpoint_01.sh`

\#\#\# 3 — Firewall \& Security  ✅

- Enable and configure `firewalld`, restrict to SSH/HTTP/HTTPS.
- Enforce SELinux.
- Validate with `firewall‑cmd` status/tests.
- **Artifacts:** `SYSTEM_SETUP.md` (firewall, SELinux), `setup_checkpoint_02.sh`

\#\#\# 4 — System Update \& Essential Tools  ✅

- Perform full updates.
- Install core utilities (`dnf htop ncdu git vim`).
- Capture package list for reproducibility.

\#\#\# 5 — Sudo / Privileges \& Groups  ✅

- Configure `/etc/sudoers`, audit wheel access.
- Document permissions (`sudo ‑l`, `id admin`).

\#\#\# 6 — Application Preparation  ✅

- Prepare storage and verify FHS layout.
- Define directory plan for Nextcloud and Forgejo.

\#\#\# 7 — Application Deployment  🚧 In Progress

- **Nextcloud:** ✅
- **Forgejo:** ✅
- **Trading (OpenBB / Ollama):** ✅
- **GNOME / KDE Multi‑DE:** ✅ Checkpoint 33 (2025‑10‑25)
- **AI‑Coop Job Tracker:** ✅ Checkpoint 34 (2025‑10‑25)

\#\#\# 8 — Maintenance \& Backup Strategy  ✅

- Automated nightly backups and systemd timers.
- Monthly restore tests (ongoing).

***

## Checkpoint Documentation Template

\#\#\# Markdown (Documentation)

```markdown
## Checkpoint X — <Short Title, Date>

**Description:**  
Summarize the objective, actions, and results. List all relevant scripts.

**Commands / Configuration:**
```

\# Exact commands, validated per test.

```

**Verification / Outcome:**
- Expected system state after execution.  
- Verification commands and log outputs.  
```

\#\#\# Shell Script (Automation)

```bash
#!/usr/bin/env bash
#===============================================================================
# Checkpoint X — <Short Title, Date>
# Purpose: <Brief description of the task>
#===============================================================================

set -euo pipefail
IFS=$'\n\t'

echo "=== Starting Checkpoint X at $(date) ==="

# Commands begin:
<commands exactly as used>

echo "=== Checkpoint X completed at $(date) ==="
```


***

\#\# References
- Asahi Linux Documentation – [https://asahilinux.org/docs/](https://asahilinux.org/docs/)
- Fedora Asahi Remix Guide – [https://docs.fedoraproject.org/en‑US/fedora‑asahi‑remix/](https://docs.fedoraproject.org/en%E2%80%91US/fedora%E2%80%91asahi%E2%80%91remix/)
- Automation Templates – `srv‑m1m‑asahi/core/scripts/`

***

Here is your **sanitized public version** of the system roadmap (`roadmap-v1.0-public.md`). This copy is ready for placement in `srv-m1m-asahi/docs/`—with internal device IDs, usernames, or specific admin notes generalized, and a strong focus on reproducibility and documentation best practices.

***

# Fedora Asahi Server: AI Handoff \& Buildout Plan (Public)

## Project Vision

Set up a world-class, reproducible, and secure Fedora Asahi Linux server environment—documented from bare metal to production for portfolio, training, and disaster recovery.
Primary hosted services: Nextcloud (cloud suite), Forgejo (version control), multi-DE (GNOME/KDE), and automation-ready AI components.

***

## Handoff Instructions (for Human or AI Collaborator)

- **Goal:**
At every major checkpoint, produce:
    - A Markdown documentation file (`SYSTEM_SETUP.md` or wiki entry) with current state, configurations, actions, rationale.
    - A companion shell script (`setup_checkpoint_<n>.sh`) with just the commands required.
- **Checkpoints:**
Any significant configuration (user, network, security, package, or application/automation change).
- **AI assistants:**
    - Clarify any ambiguity prior to running configs/scripts.
    - Summarize results in both `.md` and `.sh` at each checkpoint.

***

## Project Outline \& Checkpoints

### 1 — Initial System Install \& Access  ✅

- Base OS install, network config, first login.
- Document image versions and initial boot info.


### 2 — User \& SSH Setup  ✅

- Create core accounts; assign shells.
- Harden SSH (key-based only), test authentication, check permissions/SELinux.
- **Artifacts:** `SYSTEM_SETUP.md` (users, SSH), `setup_checkpoint_01.sh`


### 3 — Firewall \& Security  ✅

- Enable/configure firewalld; allow SSH/HTTP/HTTPS only.
- Enforce SELinux, validate via firewall/SELinux status.
- **Artifacts:** `SYSTEM_SETUP.md` (firewall, SELinux), `setup_checkpoint_02.sh`


### 4 — System Update \& Essential Tools  ✅

- Apply updates.
- Install baseline tools (`dnf`, `htop`, `ncdu`, `git`, `vim`).
- Save package list for transparency/reproducibility.


### 5 — Sudo / Privileges \& Groups  ✅

- Configure `/etc/sudoers`, audit wheel/privileged access.
- Document permissions/privilege assignments.


### 6 — Application Preparation  ✅

- Prepare and verify FHS-aligned storage.
- Plan out service/data directories for key apps (Nextcloud, Forgejo, etc).


### 7 — Application Deployment  🚧 In Progress

- Nextcloud: ✅
- Forgejo: ✅
- Trading Environment (OpenBB / Ollama): ✅
- GNOME / KDE Multi-DE: ✅ Checkpoint 33 (2025-10-25)
- AI-Coop Job Tracker: ✅ Checkpoint 34 (2025-10-25)


### 8 — Maintenance \& Backup Strategy  ✅

- Automate scheduled backups (scripted, with systemd timers).
- Run periodic restore tests and document results.

***

## Checkpoint Documentation Template

### Markdown (Documentation)

```markdown
## Checkpoint X — <Short Title, Date>

**Description:**  
Briefly describe the goal, approach, and results. List any scripts produced.

**Commands / Configuration:**
```


# All config and validated shell commands for this checkpoint.

```

**Verification / Outcome:**
- List expected system state upon completion.
- Include key verification/log output.
```


### Shell Script (Automation Template)

```bash
#!/usr/bin/env bash
#===============================================================================
# Checkpoint X — <Short Title, Date>
# Purpose: <High-level summary of automation>
#===============================================================================

set -euo pipefail
IFS=$'\n\t'

echo "=== Starting Checkpoint X at $(date) ==="

# Commands to reproduce this checkpoint go here, in order.

echo "=== Checkpoint X completed at $(date) ==="
```


***

## References

- Asahi Linux Documentation: https://asahilinux.org/docs/
- Fedora Asahi Remix Docs: https://docs.fedoraproject.org/en-US/fedora-asahi-remix/
- Automation Templates: `srv-m1m-asahi/scripts/core/`

***

**All shell scripts and documentation in this roadmap are sanitized for public sharing. Internal system identifiers, credentials, and sensitive information are removed in accordance with security standards.**

***

All config, user/account specifics, and low-level internal notes have been abstracted or omitted for safe public presentation and version control.[^1][^2]

<div align="center">⁂</div>

[^1]: https://www.itglue.com/blog/naming-conventions-examples-formats-best-practices/

[^2]: https://datamanagement.hms.harvard.edu/plan-design/file-naming-conventions

