#!/usr/bin/env bash
#===============================================================================
#  Syncthing Installation & Configuration Script
#===============================================================================
#  Author        : ch1ch0
#  Date          : 2025-11-07
#  Environment   : Fedora Asahi Remix 42 ARM64
#  Target System : Fedora Linux (aarch64)
#-------------------------------------------------------------------------------
#  Purpose       : Install Syncthing (file synchronization) as Podman container
#  Service       : Continuous file sync across devices
#  Data Location : /mnt/data/srv/syncthing/data
#  Port          : 8384 (Web UI), 22000 (Sync)
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================
APP_NAME="syncthing"
APP_VERSION="latest"
CONTAINER_IMAGE="docker.io/syncthing/syncthing:latest"
SERVICE_USER="root"
SERVICE_GROUP="root"
DATA_DIR="/mnt/data/srv/syncthing/data"
CONFIG_DIR="/mnt/data/srv/syncthing/config"
PORT_WEB="8384"
PORT_SYNC="22000"
SYSTEMD_UNIT="/etc/systemd/system/syncthing.service"
SYSTEMD_SERVICE_NAME="syncthing"

#===============================================================================
# SECTION 2: CONFIGURATION VARIABLES
#===============================================================================
read -rp "Container image [$CONTAINER_IMAGE]: " input_image
CONTAINER_IMAGE=${input_image:-$CONTAINER_IMAGE}

read -rp "Web UI port [$PORT_WEB]: " input_port
PORT_WEB=${input_port:-$PORT_WEB}

read -rp "Sync port [$PORT_SYNC]: " input_sync_port
PORT_SYNC=${input_sync_port:-$PORT_SYNC}

read -rp "Data directory [$DATA_DIR]: " input_data_dir
DATA_DIR=${input_data_dir:-$DATA_DIR}

read -rp "Config directory [$CONFIG_DIR]: " input_config_dir
CONFIG_DIR=${input_config_dir:-$CONFIG_DIR}

#===============================================================================
# SECTION 3: CONFIRMATION
#===============================================================================
echo
echo "========== SYNCTHING INSTALLATION CONFIGURATION =========="
echo "  Container Image    : $CONTAINER_IMAGE"
echo "  Web UI Port        : $PORT_WEB"
echo "  Sync Port          : $PORT_SYNC"
echo "  Data Directory     : $DATA_DIR"
echo "  Config Directory   : $CONFIG_DIR"
echo "  Service User       : $SERVICE_USER"
echo "  Systemd Unit       : $SYSTEMD_UNIT"
echo "============================================================"
echo

read -rp "Proceed with installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Installation aborted."
  exit 1
fi

#===============================================================================
# SECTION 4: PREREQUISITES
#===============================================================================
echo "[INFO] Checking prerequisites..."

# Check for Podman
if ! command -v podman &>/dev/null; then
  echo "[ERROR] Podman is not installed. Install with: sudo dnf install podman"
  exit 1
fi
echo "  ✓ Podman installed: $(podman --version)"

# Check for systemd
if ! command -v systemctl &>/dev/null; then
  echo "[ERROR] systemd is not available."
  exit 1
fi
echo "  ✓ systemd available"

#===============================================================================
# SECTION 5: CREATE DATA DIRECTORIES
#===============================================================================
echo "[INFO] Creating data and config directories..."
sudo mkdir -p "$DATA_DIR"
sudo mkdir -p "$CONFIG_DIR"
sudo chmod 755 "$DATA_DIR" "$CONFIG_DIR"
echo "  ✓ Directories created"

#===============================================================================
# SECTION 6: PULL CONTAINER IMAGE
#===============================================================================
echo "[INFO] Pulling Syncthing container image..."
echo "  Image: $CONTAINER_IMAGE"
sudo podman pull "$CONTAINER_IMAGE"

# Verify image exists
if ! sudo podman image inspect "$CONTAINER_IMAGE" &>/dev/null; then
  echo "[ERROR] Failed to pull container image."
  exit 1
fi
echo "  ✓ Image pulled successfully"

#===============================================================================
# SECTION 7: CREATE SYSTEMD SERVICE UNIT
#===============================================================================
echo "[INFO] Creating systemd service unit..."
sudo tee "$SYSTEMD_UNIT" > /dev/null <<EOF
[Unit]
Description=Syncthing (Podman Container)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_GROUP
Restart=always
RestartSec=5
ExecStartPre=/bin/bash -c '/usr/bin/podman rm -f syncthing-container 2>/dev/null || true'
ExecStart=/usr/bin/podman run \\
  --name=syncthing-container \\
  --detach \\
  --publish=0.0.0.0:${PORT_WEB}:8384 \\
  --publish=0.0.0.0:${PORT_SYNC}:22000 \\
  --publish=0.0.0.0:22000:22000/udp \\
  --volume=${DATA_DIR}:/var/syncthing:Z \\
  --volume=${CONFIG_DIR}:/var/syncthing/config:Z \\
  --hostname=ch1ch0-m1m \\
  --env PUID=0 \\
  --env PGID=0 \\
  $CONTAINER_IMAGE

ExecStop=/usr/bin/podman stop syncthing-container

[Install]
WantedBy=multi-user.target
EOF

echo "  ✓ Systemd unit created at $SYSTEMD_UNIT"

#===============================================================================
# SECTION 8: ENABLE & START SERVICE
#===============================================================================
echo "[INFO] Enabling and starting Syncthing service..."
sudo systemctl daemon-reload
sudo systemctl enable "$SYSTEMD_SERVICE_NAME"
sudo systemctl start "$SYSTEMD_SERVICE_NAME"

# Wait for container to start
sleep 3

#===============================================================================
# SECTION 9: VERIFICATION
#===============================================================================
echo "[INFO] Verifying installation..."
if sudo systemctl is-active --quiet "$SYSTEMD_SERVICE_NAME"; then
  echo "  ✓ Service is running"
  sudo systemctl status "$SYSTEMD_SERVICE_NAME" --no-pager | head -10
else
  echo "  ✗ Service failed to start"
  sudo journalctl -u "$SYSTEMD_SERVICE_NAME" -n 20
  exit 1
fi

# Check if container is accessible
if sudo podman ps | grep -q syncthing-container; then
  echo "  ✓ Container is running"
  CONTAINER_ID=$(sudo podman ps | grep syncthing-container | awk '{print $1}')
  echo "  ✓ Container ID: $CONTAINER_ID"
else
  echo "  ✗ Container failed to start"
  exit 1
fi

#===============================================================================
# SECTION 10: POST-INSTALLATION INFORMATION
#===============================================================================
echo
echo "========== SYNCTHING INSTALLATION COMPLETE =========="
echo
echo "Access Syncthing Web UI at:"
echo "  http://192.168.1.64:${PORT_WEB}/"
echo
echo "Sync Configuration:"
echo "  Sync Port (TCP/UDP) : $PORT_SYNC"
echo "  Data Directory      : $DATA_DIR"
echo "  Config Directory    : $CONFIG_DIR"
echo
echo "Service Management:"
echo "  Start   : sudo systemctl start $SYSTEMD_SERVICE_NAME"
echo "  Stop    : sudo systemctl stop $SYSTEMD_SERVICE_NAME"
echo "  Restart : sudo systemctl restart $SYSTEMD_SERVICE_NAME"
echo "  Status  : sudo systemctl status $SYSTEMD_SERVICE_NAME"
echo "  Logs    : sudo journalctl -u $SYSTEMD_SERVICE_NAME -f"
echo
echo "Initial Setup:"
echo "  1. Navigate to http://192.168.1.64:${PORT_WEB}/"
echo "  2. Configure username and password"
echo "  3. Add folders to sync"
echo "  4. Connect other devices (use QR code or device ID)"
echo "  5. Device will appear in config directory"
echo
echo "Next Steps:"
echo "  • Configure folders in Web UI"
echo "  • Add other devices (phones, laptops)"
echo "  • Back up $CONFIG_DIR regularly"
echo "  • Monitor logs for sync issues"
echo
echo "========================================================"
echo "[SUCCESS] Syncthing installed and configured successfully."