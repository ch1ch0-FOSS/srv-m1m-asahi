# Fedora Asahi Server: AI Handoff & Buildout Plan

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

### 1. Initial System Install & Access ([DONE])
- Install Fedora/Asahi, set up networking, first login.
- Document image versions, device identifiers, and initial accounts.

### 2. User & SSH Setup ([DONE])
- Create admin and user accounts, assign shells.
- Harden SSH, deploy and test keys, check permissions and SELinux.
- **Artifacts:** SYSTEM_SETUP.md (users, shells, SSH), setup_checkpoint_01.sh

### 3. Firewall & Security ([DONE])
- Enable and configure firewalld; restrict to SSH/HTTP/HTTPS only.
- Set SELinux to enforcing.
- Test and log firewall status/settings.
- **Artifacts:** SYSTEM_SETUP.md (firewalld, SELinux), setup_checkpoint_02.sh

### 4. System Update & Essential Tools ([DONE])
- Full system update.
- Install core utilities (dnf, htop, ncdu, etc).
- Document current package list for reproducibility.

### 5. Sudo/Privilege & Groups ([DONE])
- Configure/administer sudoers.
- Review and document all user privileges and group assignments.

### 6. Application Prep  ([DONE])
- Prepare storage and directories using FHS.
- Plan/record data locations for Nextcloud, Forgejo, etc.

### 7. Application Deployment  
- Document setup/installation, config, and security of each service.
- Update documentation and scripts with every config or problem/solution.

### 8. Ongoing Maintenance & Backup Strategy  
- Schedule and script updates, checks, and backup testing.
- Document routine maintenance and health check commands.

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
[1] selected_image_6007554436595579861.jpg https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/images/81945704/a200289d-a68d-4035-b642-a4f95b42f094/selected_image_6007554436595579861.jpg

