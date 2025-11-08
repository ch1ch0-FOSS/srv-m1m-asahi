#!/usr/bin/env bash
#===============================================================================
#  Vaultwarden Installation & Configuration Script
#===============================================================================
#  Author        : ch1ch0
#  Date          : 2025-11-07
#  Environment   : Fedora Asahi Remix 42 ARM64
#  Target System : Fedora Linux (aarch64)
#-------------------------------------------------------------------------------
#  Purpose       : Install Vaultwarden (password vault) as Podman container
#  Service       : Bitwarden-compatible password manager
#  Data Location : /mnt/data/srv/vaultwarden/data
#  Port          : 8000 (HTTP), 3012 (WebSocket)
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================
APP_NAME="vaultwarden"
APP_VERSION="latest"
CONTAINER_IMAGE="docker.io/vaultwarden/server:latest"
SERVICE_USER="root"
SERVICE_GROUP="root"
DATA_DIR="/mnt/data/srv/vaultwarden/data"
PORT_HTTP="8000"
PORT_WS="3012"
SYSTEMD_UNIT="/etc/systemd/system/vaultwarden.service"
SYSTEMD_SERVICE_NAME="vaultwarden"

#===============================================================================
# SECTION 2: CONFIGURATION VARIABLES
#===============================================================================
read -rp "Container image [$CONTAINER_IMAGE]: " input_image
CONTAINER_IMAGE=${input_image:-$CONTAINER_IMAGE}

read -rp "HTTP port [$PORT_HTTP]: " input_port
PORT_HTTP=${input_port:-$PORT_HTTP}

read -rp "WebSocket port [$PORT_WS]: " input_ws_port
PORT_WS=${input_ws_port:-$PORT_WS}

read -rp "Data directory [$DATA_DIR]: " input_data_dir
DATA_DIR=${input_data_dir:-$DATA_DIR}

#===============================================================================
# SECTION 3: CONFIRMATION
#===============================================================================
echo
echo "========== VAULTWARDEN INSTALLATION CONFIGURATION =========="
echo "  Container Image    : $CONTAINER_IMAGE"
echo "  HTTP Port          : $PORT_HTTP"
echo "  WebSocket Port     : $PORT_WS"
echo "  Data Directory     : $DATA_DIR"
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
# SECTION 5: CREATE DATA DIRECTORY
#===============================================================================
echo "[INFO] Creating data directory..."
sudo mkdir -p "$DATA_DIR"
sudo chmod 755 "$DATA_DIR"
ls -la "$DATA_DIR"

#===============================================================================
# SECTION 6: PULL CONTAINER IMAGE
#===============================================================================
echo "[INFO] Pulling Vaultwarden container image..."
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
Description=Vaultwarden (Podman Container)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_GROUP
Restart=always
RestartSec=5
ExecStartPre=/bin/bash -c '/usr/bin/podman rm -f vaultwarden-container 2>/dev/null || true'
ExecStart=/usr/bin/podman run \\
  --name=vaultwarden-container \\
  --detach \\
  --publish=0.0.0.0:${PORT_HTTP}:80 \\
  --publish=0.0.0.0:${PORT_WS}:3012 \\
  --volume=${DATA_DIR}:/data:Z \\
  --env DOMAIN=http://192.168.1.64:${PORT_HTTP} \\
  --env SIGNUPS_ALLOWED=true \\
  --env INVITATIONS_ALLOWED=true \\
  --env SEND_PURGE_SCHEDULE="30 3 * * *" \\
  --env LOG_FILE=/data/vaultwarden.log \\
  $CONTAINER_IMAGE

ExecStop=/usr/bin/podman stop vaultwarden-container

[Install]
WantedBy=multi-user.target
EOF

echo "  ✓ Systemd unit created at $SYSTEMD_UNIT"

#===============================================================================
# SECTION 8: ENABLE & START SERVICE
#===============================================================================
echo "[INFO] Enabling and starting Vaultwarden service..."
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
if sudo podman ps | grep -q vaultwarden-container; then
  echo "  ✓ Container is running"
  CONTAINER_ID=$(sudo podman ps | grep vaultwarden-container | awk '{print $1}')
  echo "  ✓ Container ID: $CONTAINER_ID"
else
  echo "  ✗ Container failed to start"
  exit 1
fi

#===============================================================================
# SECTION 10: POST-INSTALLATION INFORMATION
#===============================================================================
echo
echo "========== VAULTWARDEN INSTALLATION COMPLETE =========="
echo
echo "Access Vaultwarden at:"
echo "  Web UI   : http://192.168.1.64:${PORT_HTTP}/"
echo "  WebSocket: ws://192.168.1.64:${PORT_WS}/"
echo
echo "Data Location : $DATA_DIR"
echo "Log File      : $DATA_DIR/vaultwarden.log"
echo
echo "Service Management:"
echo "  Start   : sudo systemctl start $SYSTEMD_SERVICE_NAME"
echo "  Stop    : sudo systemctl stop $SYSTEMD_SERVICE_NAME"
echo "  Restart : sudo systemctl restart $SYSTEMD_SERVICE_NAME"
echo "  Status  : sudo systemctl status $SYSTEMD_SERVICE_NAME"
echo "  Logs    : sudo journalctl -u $SYSTEMD_SERVICE_NAME -f"
echo
echo "Next Steps:"
echo "  1. Navigate to http://192.168.1.64:${PORT_HTTP}/"
echo "  2. Disable registrations after creating admin account (optional)"
echo "  3. Configure DOMAIN in systemd unit if using HTTPS"
echo "  4. Back up $DATA_DIR regularly"
echo
echo "=========================================================="
echo "[SUCCESS] Vaultwarden installed and configured successfully."