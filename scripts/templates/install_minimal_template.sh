***
# 📂 **Minimalist Linux Application Install Template**

```bash
#!/usr/bin/env bash
#===============================================================================
# Minimalist Install Template - for quick app/script deployment
#===============================================================================
set -euo pipefail

#--- VARIABLES
APP_NAME="<app-name>"
APP_VERSION="<version>"
APP_USER="<user>"
APP_GROUP="<group>"
PKG_MANAGER="<apt|dnf|yum|pacman|zypper>"
DOWNLOAD_URL="<url-to-tarball-or-binary>"
CHECKSUM="<sha256sum>"

#--- DEPENDENCIES
case "$PKG_MANAGER" in
  apt) apt-get update && apt-get install -y curl tar ;;
  dnf|yum) $PKG_MANAGER install -y curl tar ;;
  pacman) pacman -Sy --noconfirm curl tar ;;
  zypper) zypper install -y curl tar ;;
esac

#--- DOWNLOAD
cd /tmp
curl -LO "${DOWNLOAD_URL}"
echo "${CHECKSUM}  <archive-file>" | sha256sum -c -

#--- INSTALL
mkdir -p /opt/${APP_NAME}
tar -xf <archive-file> -C /opt/${APP_NAME} --strip=1
ln -sf /opt/${APP_NAME}/bin/${APP_NAME} /usr/local/bin/${APP_NAME}

#--- USER + PERMISSIONS
getent group ${APP_GROUP} >/dev/null || groupadd --system ${APP_GROUP}
id -u ${APP_USER} &>/dev/null || \
  useradd --system --no-create-home -g ${APP_GROUP} -d /opt/${APP_NAME} ${APP_USER}
chown -R ${APP_USER}:${APP_GROUP} /opt/${APP_NAME}

#--- SYSTEMD (optional)
cat > /etc/systemd/system/${APP_NAME}.service <<EOF
[Unit]
Description=${APP_NAME} Service
After=network.target

[Service]
ExecStart=/usr/local/bin/${APP_NAME}
Restart=always
User=${APP_USER}
Group=${APP_GROUP}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now ${APP_NAME}

#--- VERIFY
${APP_NAME} --version || echo "[INFO] App installed."
```


***

# 🔑 **Minimalist Workflow**

1. Save file:

```bash
vim install-minimal.sh
```

2. Replace `<placeholders>` (name, version, URL, checksum).
3. Execute:

```bash
chmod +x install-minimal.sh && sudo ./install-minimal.sh
```

4. Confirm:

```bash
systemctl status <app-name>
```


***

⚡️ Difference:

- **Enterprise Skeleton** = full governance/audit (configs, logs, rich service template).
- **Minimalist Variant** = lean < 100 lines, fast deploy for dev/prod parity with minimal overhead.

***

