# \# 🛠️ admin‑toolkit

**Linux System Administration Tools \& Best Practices**

A curated collection of scripts, configuration templates, and documentation developed through managing the Fedora Asahi M1 infrastructure (`srv‑m1m‑asahi`). Each tool embodies simplicity, repeatability, and clear documentation.

---

## 📋 Contents

| Directory | Description |
| :-- | :-- |
| **scripts/** | Bash utilities for backups, monitoring, permission resets, and system verification |
| **templates/** | systemd unit stubs, bash headers, log docstrings |
| **docs/** | Usage guides and troubleshooting notes per tool |


---

## 🚀 Featured Tools

### backup_all.sh

Creates comprehensive rsync + MariaDB snapshot backups executed by a nightly systemd timer.

### setup_checkpoint.sh

Baseline configuration checkpoint utility – generates FHS verification, package manifest, and user snapshot.

### fedora_bootstrap.sh

Automates post‑install setup for new Fedora systems, ensuring SELinux enforcement, firewall activation, SSH hardening, and base package installations.

---

## 💡 Best Practices and Philosophy

- **KISS Principle:** clear, concise, repeatable code.
- **Document Every Change:** commits must reference corresponding doc updates.
- **Automation First:** anything done twice gets scripted.
- **Security by Default:** enforce SELinux, firewalld, key‑only SSH.

---

## 🎓 Learning Outcomes / Skill Demonstration

Demonstrates proficiency in:

- Shell scripting and automation
- System init and service management via systemd
- Linux package and user administration
- Robust logging and backup strategies
- Reproducible configuration design

---

## 💾 Usage Example

Clone and inspect

git clone [https://github.com/ch1ch0-FOSS/admin-toolkit.git](https://github.com/ch1ch0-FOSS/admin-toolkit.git)
cd admin-toolkit/scripts

\# Run maintenance script in dry‑run mode
bash backup_all.sh --dry-run

---

## 🧭 For Reviewers / Hiring Managers

This repository highlights:

- Practical server automation applied to a live Fedora Asahi environment
- Enterprise‑style documentation and process discipline
- Real‑world troubleshooting reflected in commits and docs

Perfect — that README already demonstrates strong technical maturity and structure.
Let’s expand it slightly so it ties seamlessly into your **srv‑m1m‑asahi public portfolio**, while cleanly referencing the **private admin toolkit** and **AI‑Coop automation layers**.

Below is a **ready‑to‑paste, fully optimized version** for `/mnt/data/srv‑m1m‑asahi/README.md` — it complements your `.gitignore_public`, the `docs/roadmap‑v1.0.md`, and your dual‑environment workflow.

***

# 🧭 Fedora Asahi Infrastructure Portfolio

**Documentation‑Driven System Administration \& Automation**

This repository is a **public‑facing portfolio** of the live Fedora Asahi M1 server (`srv‑m1m‑asahi`) — engineered for reproducibility, auditability, and hybrid AI‑human workflow demonstration.
It mirrors production‑grade practices developed within the corresponding private `admin‑toolkit` repository.

***

## 📁 Repository Contents

| Directory | Purpose |
| :-- | :-- |
| `core/` | Baseline setup checkpoints and installation scripts (e.g., packages, sudo policy, network hardening) |
| `automation/` | Backup and maintenance scripts with systemd integration |
| `ai‑coop/` | AI‑assisted workflow and documentation automation (checkpoints 33–38) |
| `docs/` | System setup records, roadmaps, troubleshooting guides, and changelogs |
| `scripts/` | General automation and utility shell scripts |
| `users/` | Portfolio materials for user environments (e.g., GUI screenshots for GNOME/KDE) |


***

## 🚀 Current System Highlights

### Fedora Asahi Remix 42  (Apple Silicon M1)

- FHS‑compliant storage layout (`/mnt/data` primary)
- SELinux enforcing  ·  firewalld active  ·  key‑only SSH
- Forgejo (git) + Nextcloud stack with automated backups

\#\#\# Desktop Integration (Checkpoint 33)
GNOME and KDE environments implemented under `ch1ch0` for demonstration of multi‑user, multi‑DE support via GDM.

\#\#\# AI‑Coop Automation Pipelines (Checkpoint 34 +)
Local AI agents assist in:

- Documentation generation and checkpoint logging (`ai‑handoff.md`)
- CSV / Markdown synchronization via automated job tracker
- Scheduled `system‑index` audits for SELinux and firewall integrity

***

## 💎 Public vs Private Structure

| Layer | Path | Visibility | Purpose |
| :-- | :-- | :-- | :-- |
| Public (repo) | `/mnt/data/srv‑m1m‑asahi` | Published to Forgejo + GitHub | Demonstrate skills \& audit workflow |
| Private (admin) | `/mnt/data/admin` | Local‑only (secured by `.gitignore_admin`) | Contains keys, credentials, audit logs |
| User workspace | `/mnt/data/ch1ch0` | Working space for daily tasks | Development, testing, and portfolio capture |

The `.gitignore_public` in this repo maintains a clean, security‑safe state while the admin repository retains sensitive details privately.

***

## ⚙️ Key Documents

| File | Function |
| :-- | :-- |
| `docs/system‑setup‑v1.0.md` | Complete baseline setup reference (Fedora Asahi installation → services) |
| `docs/roadmap‑v1.0.md` | Checkpoint history and future milestones |
| `docs/users.md` | Public user overview (redacted; admin version stored privately) |
| `docs/ai‑handoff.md` | Human‑AI handoff protocol and checkpoint audit rules |


***

## 📜 Best Practices

- **Automation First:** Every repeatable administrative task is scripted.
- **Documentation as Infrastructure:** Each change is logged and verified through checkpoint scripts.
- **Security by Default:** Key‑only SSH, SELinux enforcing, limited wheel membership.
- **Transparency through Version Control:** All system logic and test notes maintained in Git.

***

## 🧠 Skill Showcase

- System Engineering on Apple Silicon Asahi hardware
- Bash automation and GitOps discipline
- Network and service security auditing
- Backup and restore systems via `rsync` and `mysqldump`
- Human‑AI collaboration for documented operations

***

## 📬 For Reviewers / Collaborators

This repository demonstrates real‑world system administration capabilities and workflow design.
Private data has been sanitized for public audit, with all critical logic retained for verifiability.
Full operational scripts and unredacted docs exist within the `admin‑toolkit` repository on the same host.

***

## 🔗 Related Projects

- **admin‑toolkit** — Private repository containing secure automation and audit records
- **AI‑Coop** — Experimental AI‑administration frameworks and automation pipelines

***

