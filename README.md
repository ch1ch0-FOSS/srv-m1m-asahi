# # 🛠️ admin‑toolkit

**Linux System Administration Tools & Best Practices**

A curated collection of scripts, configuration templates, and documentation developed through managing the Fedora Asahi M1 infrastructure (`srv‑m1m‑asahi`). Each tool embodies simplicity, repeatability, and clear documentation.

---

## 📋 Contents

| Directory | Description |
|:-----------|:------------|
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

git clone https://github.com/ch1ch0-FOSS/admin-toolkit.git
cd admin-toolkit/scripts

# Run maintenance script in dry‑run mode
bash backup_all.sh --dry-run

---

## 🧭 For Reviewers / Hiring Managers
This repository highlights:
- Practical server automation applied to a live Fedora Asahi environment  
- Enterprise‑style documentation and process discipline  
- Real‑world troubleshooting reflected in commits and docs  

