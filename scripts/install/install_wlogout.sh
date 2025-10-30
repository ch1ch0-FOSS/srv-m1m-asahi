#!/usr/bin/env bash
#===============================================================================
#  wlogout Installation - Wayland Logout Menu
#===============================================================================
#  Author        : ch1ch0
#  Date          : 2025-10-27
#  Environment   : Fedora Asahi Remix 42 ARM64
#  Target System : sysadmin@asahi-m1m
#  Checkpoint    : 36
#-------------------------------------------------------------------------------
#  Purpose       : Install wlogout for Sway session management
#  Notes         : Requires Sway (Checkpoint 35). Builds from source.
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================
APP_NAME="wlogout"
PKG_MANAGER="dnf"
INSTALL_DIR="/opt/wlogout"
CONFIG_DIR="$HOME/.config/wlogout"
DOWNLOAD_URL="https://github.com/ArtsyMacaw/wlogout.git"
DEPENDENCIES=(
  "gtk3-devel"
  "gobject-introspection-devel"
  "meson"
  "ninja-build"
  "gtk-layer-shell-devel"
  "scdoc"
  "systemd-devel"
  "git"
  "gcc"
)

#===============================================================================
# SECTION 2: CONFIRMATION
#===============================================================================
echo "=========================================="
echo "wlogout Installation for Sway"
echo "=========================================="
echo "This will:"
echo "  - Install build dependencies"
echo "  - Clone and build wlogout from source"
echo "  - Install to system (/usr/local/)"
echo "  - Deploy default configs to ~/.config/wlogout/"
echo ""
read -rp "Proceed with installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Installation aborted."
  exit 1
fi

#===============================================================================
# SECTION 3: INSTALL DEPENDENCIES
#===============================================================================
echo "[INFO] Installing build dependencies..."
sudo dnf install -y "${DEPENDENCIES[@]}"

#===============================================================================
# SECTION 4: CLONE AND BUILD
#===============================================================================
echo "[INFO] Cloning wlogout repository..."
sudo mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

if [ -d "$INSTALL_DIR/.git" ]; then
  echo "[INFO] Repository exists, pulling latest changes..."
  sudo git pull
else
  echo "[INFO] Cloning repository..."
  sudo git clone --depth 1 "$DOWNLOAD_URL" .
fi

echo "[INFO] Building wlogout with meson..."
sudo meson build
sudo ninja -C build
sudo ninja -C build install

#===============================================================================
# SECTION 5: DEPLOY CONFIGS
#===============================================================================
echo "[INFO] Deploying default configuration..."
mkdir -p "$CONFIG_DIR"

# Copy default layout and style if they exist
if [ -f /etc/wlogout/layout ]; then
  cp /etc/wlogout/layout "$CONFIG_DIR/"
  echo "[INFO] Copied default layout to $CONFIG_DIR/"
fi

if [ -f /etc/wlogout/style.css ]; then
  cp /etc/wlogout/style.css "$CONFIG_DIR/"
  echo "[INFO] Copied default style to $CONFIG_DIR/"
fi

#===============================================================================
# SECTION 6: INTEGRATE WITH SWAY
#===============================================================================
SWAY_CONFIG="$HOME/.config/sway/config"
if [ -f "$SWAY_CONFIG" ]; then
  if ! grep -q "wlogout" "$SWAY_CONFIG"; then
    echo "[INFO] Adding wlogout keybind to Sway config..."
    cat >> "$SWAY_CONFIG" << 'EOF'

# wlogout - Session management
bindsym $mod+Shift+x exec wlogout
EOF
    echo "[INFO] Added keybind: Super+Shift+X launches wlogout"
  else
    echo "[INFO] wlogout already integrated in Sway config"
  fi
fi

#===============================================================================
# SECTION 7: VERIFICATION
#===============================================================================
echo "[INFO] Verifying installation..."
if command -v wlogout &>/dev/null; then
  wlogout --version || echo "[INFO] wlogout installed (version info unavailable)"
  echo "[SUCCESS] wlogout is now in PATH"
else
  echo "[WARN] wlogout not found in PATH. Check installation."
fi

#===============================================================================
# SECTION 8: POST-INSTALL NOTES
#===============================================================================
echo ""
echo "=========================================="
echo "wlogout Installation Complete"
echo "=========================================="
echo ""
echo "Usage:"
echo "  - Launch from terminal: wlogout"
echo "  - Sway keybind: Super+Shift+X"
echo "  - Press Escape to exit menu"
echo ""
echo "Configuration:"
echo "  - Layout: $CONFIG_DIR/layout"
echo "  - Styling: $CONFIG_DIR/style.css"
echo ""
echo "To apply new keybind:"
echo "  - Reload Sway: Super+Shift+C"
echo "  - Or run: swaymsg reload"
echo ""

