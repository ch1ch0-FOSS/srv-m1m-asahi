# System Setup: Fedora Asahi M1 Server  
*Audit-ready, FHS-aligned checkpoints for repeatable Linux automation and self-hosting*

***

## Checkpoint 1: Initial System Install & Access (2025-09-18)
**Description:**  
Installed Fedora Asahi on M1 Mac Mini. Set up networking, users, SSH.  
Documented base image, partition map, and device UIDs.

**Commands/Config:**  
```bash
hostnamectl set-hostname srv-m1m-asahi
ip a    # Record interface details
```

**Outcome:**  
- System boots, network up, SSH login works.

***

## Checkpoint 2: User & SSH Setup (2025-09-19)
**Description:**  
Created 'admin' and 'ch1ch0', set shells. Hardened SSH (key-only login), configured SELinux.

**Commands/Config:**  
```bash
sudo adduser admin
sudo adduser ch1ch0
sudo usermod -s /bin/bash admin
sudo usermod -s /bin/bash ch1ch0
sudo mkdir /home/admin/.ssh
sudo cp /home/admin/.ssh/authorized_keys /home/admin/.ssh/authorized_keys
sudo chmod 700 /home/admin/.ssh
sudo chmod 600 /home/admin/.ssh/authorized_keys
sudo vi /etc/ssh/sshd_config    # Set PasswordAuthentication no
sudo systemctl restart sshd
sestatus
```

**Outcome:**  
- Key-based SSH only, correct shell defaults, SELinux enforcing.

***

## Checkpoint 3: Firewall & Security (2025-09-20)
**Description:**  
Enabled/configured `firewalld`. Allowed SSH (22), HTTP (80), HTTPS (443).  
SELinux enforcing; all status/configs logged.

**Commands/Config:**  
```bash
sudo systemctl enable --now firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
sudo setenforce 1
sudo getenforce
sudo firewall-cmd --list-all
```

**Outcome:**  
- Only approved ports open, SELinux enforcing and logged.

***

## Checkpoint 4: System Update & Essential Tools (2025-09-21)
**Description:**  
Full system update, installed sysadmin tools (dnf, htop, ncdu, wget, vim/nvim, curl, git, etc.). Logged all installed packages.

**Commands/Config:**  
```bash
sudo dnf update -y
sudo dnf install -y htop ncdu vim nano wget curl git nnn ranger mc
rpm -qa > /mnt/data/logs/package_audit_2025-09-21.txt
```

**Outcome:**  
- All tools available, package audit saved.

***

## Checkpoint 5: Sudo/Privilege & Groups (2025-09-22)
**Description:**  
Configured sudoers (least privilege). Audited and adjusted group memberships.  
Hardened `/etc/sudoers`, validated required command access.

**Commands/Config:**  
```bash
sudo visudo    # Add admin/ch1ch0 sudo rules
sudo usermod -aG wheel admin
sudo usermod -aG wheel ch1ch0
id admin
id ch1ch0
sudo -l
```

**Outcome:**  
- Only approved users in 'wheel', privilege escalation minimal, config matches policy.

***

## Checkpoint 6: Storage, Directory Foundation & App Hosting Prep (2025-09-26)
**Description:**  
Mounted SSDs: `/mnt/data` and `/mnt/fastdata`. Created FHS directories for Nextcloud, Forgejo, Mastodon, Matrix in `/mnt/data/`, `/var/lib/`, `/var/log/`, `/etc/`. Archived old data.

**Commands/Config:**  
```bash
sudo mkdir -p /mnt/data /mnt/fastdata
# Configure /etc/fstab
sudo mount -a
for app in nextcloud forgejo mastodon matrix; do
  sudo mkdir -p /mnt/data/srv/$app /mnt/data/var/lib/$app /mnt/data/var/log/$app /mnt/data/etc/$app
done
sudo mkdir -p /mnt/data/archive-old
sudo mv /mnt/data/forgejo /mnt/data/archive-old/
sudo mv /mnt/data/git /mnt/data/archive-old/
sudo mv /mnt/data/nextcloud-data /mnt/data/archive-old/
```

**Outcome:**  
- SSDs mounted, all FHS directories in place. Legacy data archived for safety.

***

## Checkpoint 7: Forgejo Install & Hardened Service (2025-09-28)

**Description:**  
Installed Forgejo on ARM64 as a systemd service with MariaDB, using FHS-compliant paths. Forgejo runs as `git`, all repos/logs/data owned by `git`. Hardened service definition, explicit working directory, and secure DB/user setup.

**Commands/Config:**  
```bash
# Dependencies
sudo dnf install -y mariadb-server git git-lfs wget

# Service user
sudo useradd --system --shell /bin/bash --comment "Git Version Control" --create-home --home-dir /home/git git || true

# FHS directories and permissions
sudo mkdir -p /var/lib/forgejo/data/forgejo-repositories /var/lib/forgejo/data/lfs /var/lib/forgejo/data/log
sudo chown -R git:git /var/lib/forgejo

# MariaDB setup and database/user
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -u root -p -e "CREATE DATABASE forgejo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE USER 'ch1ch0'@'localhost' IDENTIFIED BY 'REPLACE_ME';
  GRANT ALL PRIVILEGES ON forgejo.* TO 'ch1ch0'@'localhost';
  FLUSH PRIVILEGES;"

# Forgejo binary (arm64)
sudo wget -O /usr/bin/forgejo https://codeberg.org/forgejo/forgejo/releases/download/v1.20.1-0/forgejo-1.20.1-0-linux-arm64
sudo chmod 755 /usr/bin/forgejo

# Forgejo systemd unit
sudo tee /etc/systemd/system/forgejo.service <<EOF
[Unit]
Description=Forgejo (Beyond coding. We forge.)
After=network.target

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/forgejo
Environment=USER=git HOME=/home/git FORGEJO_WORK_DIR=/var/lib/forgejo
ExecStart=/usr/bin/forgejo web --config /etc/forgejo/app.ini
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now forgejo.service

# Run installer wizard (first run; setup at http://192.168.1.64:3000/)
sudo -u git FORGEJO_WORK_DIR=/var/lib/forgejo /usr/bin/forgejo web
```

**Key Wizard Inputs:**

| Field                    | Value                                         |
|--------------------------|-----------------------------------------------|
| Repository Root Path     | /var/lib/forgejo/data/forgejo-repositories    |
| Git LFS Root Path        | /var/lib/forgejo/data/lfs                     |
| Log Path                 | /var/lib/forgejo/data/log                     |
| Run As Username          | git                                           |
| Server Domain            | 192.168.1.64                                  |
| Forgejo HTTP Listen Port | 3000                                          |
| Forgejo Base URL         | http://192.168.1.64:3000/                     |
| Database Type            | MySQL                                         |
| DB Host                  | 127.0.0.1:3306                                |
| DB User                  | ch1ch0                                        |
| DB Name                  | forgejo                                       |
| DB Password              | (set above)                                   |

**Outcome:**  
- Forgejo systemd service running (verified with `sudo systemctl status forgejo.service`)
- All Forgejo data FHS-compliant, owned by git
- MariaDB backend secure and functional
- Web UI accessible at `http://192.168.1.64:3000/`
- App management, backup, audit, and upgrades future-proofed

***

*Cont## Checkpoint X: Nextcloud Stack Deployment (2025-09-28)

**Description:**
This checkpoint deployed the full Nextcloud suite for user `ch1ch0` on Fedora Asahi Linux, establishing a local-first cloud sync compatible with the Nextcloud mobile app. Installation used Fedora RPMs for core dependencies. Service ownership, SELinux configuration, database/user separation, and initial app enabling via Nextcloud UI were completed. Script: `setup_checkpoint_X.sh` automates install and logging.

**Relevant Commands/Config:**

sudo dnf install -y nextcloud mariadb-server php php-fpm php-mysqlnd php-gd php-xml php-mbstring php-intl php-json php-zip redis nginx policycoreutils-python-utils firewalldsudo systemctl enable --now httpd mariadb php-fpm redis firewalld

sudo mysql -u root -p

In MariaDB shell:

CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'STRONG_PASSWORD';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EXIT;

sudo chown -R apache:apache /var/lib/nextcloud /etc/nextcloud
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/lib/nextcloud(/.*)?"
sudo restorecon -Rv /var/lib/nextcloudi


**Verification/Outcome:**
- Services (`httpd`, `mariadb`, `php-fpm`, `redis`, `firewalld`) are active (`systemctl status ...`).
- MariaDB shows both `forgejo` and `nextcloud` databases (`SHOW DATABASES;`).
- Nextcloud accessible at `http://<LAN_IP>/nextcloud`.
- Able to install and enable Nextcloud apps via web UI.
- Pixel Fold mobile app sync works with all enabled Nextcloud apps.
- All changes logged by script, no disruption to Forgejo or other services.
