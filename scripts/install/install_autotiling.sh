#!/usr/bin/env bash
#===============================================================================
#  Application Installation Template - Reusable, Modular, and Interactive
#===============================================================================
#  Author        : ch1ch0
#  Date          : 2025-10-29
#  Environment   : Fedora Asahi Remix 41 ARM64
#  Target System : ch1ch0@asahi-m1m
#-------------------------------------------------------------------------------
#  Purpose       : Install and configure autotiling consistently
#  Notes         : Installs via git, sets permissions, and handles dependencies
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES (Default placeholders; Edit per install)
#===============================================================================
APP_NAME="autotiling"
APP_VERSION="1.9.3"
PKG_MANAGER="dnf"
INSTALL_DIR="$HOME/git/clones/$APP_NAME"
CONFIG_DIR="$HOME/.config/$APP_NAME"
BIN_PATH="$HOME/.local/bin/$APP_NAME"
DOWNLOAD_URL="https://github.com/nwg-piotr/autotiling.git"
DEPENDENCIES=("python3" "python3-pip" "python3-i3ipc")
CUSTOM_COMMANDS=(
  # Install Python requirement (i3ipc) if not present, as fallback
  "python3 -m pip install --user i3ipc"
  # Copy script to bin
  "cp $INSTALL_DIR/main.py $BIN_PATH && chmod +x $BIN_PATH"
)

#===============================================================================
# SECTION 2: USER INPUT TO OVERRIDE DEFAULTS (Optional)
#===============================================================================
read -rp "Application name [$APP_NAME]: " input_app_name
APP_NAME=${input_app_name:-$APP_NAME}

read -rp "Application version [$APP_VERSION]: " input_app_version
APP_VERSION=${input_app_version:-$APP_VERSION}

read -rp "Package manager [$PKG_MANAGER]: " input_pkg_manager
PKG_MANAGER=${input_pkg_manager:-$PKG_MANAGER}

read -rp "Install directory [$INSTALL_DIR]: " input_install_dir
INSTALL_DIR=${input_install_dir:-$INSTALL_DIR}

read -rp "Config directory [$CONFIG_DIR]: " input_config_dir
CONFIG_DIR=${input_config_dir:-$CONFIG_DIR}

read -rp "Binary path [$BIN_PATH]: " input_bin_path
BIN_PATH=${input_bin_path:-$BIN_PATH}

#===============================================================================
# SECTION 3: CONFIRMATION BEFORE RUNNING
#===============================================================================
echo
echo "Please confirm installation configuration:"
echo "  Application Name  : $APP_NAME"
echo "  Version           : $APP_VERSION"
echo "  Package Manager   : $PKG_MANAGER"
echo "  Install Directory : $INSTALL_DIR"
echo "  Config Directory  : $CONFIG_DIR"
echo "  Binary Path       : $BIN_PATH"
echo "  Dependencies      : ${DEPENDENCIES[*]}"
echo

read -rp "Proceed with installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Installation aborted."
  exit 1
fi

#===============================================================================
# SECTION 4: INSTALL DEPENDENCIES
#===============================================================================
echo "[INFO] Installing dependencies..."
case "$PKG_MANAGER" in
  apt)
    sudo apt-get update
    sudo apt-get install -y "${DEPENDENCIES[@]}"
    ;;
  dnf)
    sudo dnf install -y "${DEPENDENCIES[@]}"
    ;;
  yum)
    sudo yum install -y "${DEPENDENCIES[@]}"
    ;;
  zypper)
    sudo zypper install -y "${DEPENDENCIES[@]}"
    ;;
  pacman)
    sudo pacman -Syu --noconfirm "${DEPENDENCIES[@]}"
    ;;
  *)
    echo "[ERROR] Unsupported package manager: $PKG_MANAGER"
    exit 1
    ;;
esac

#===============================================================================
# SECTION 5: INSTALLATION STEPS
#===============================================================================
echo "[INFO] Running installation steps..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "[INFO] Repository exists, pulling latest changes..."
  git pull
else
  echo "[INFO] Cloning repository..."
  git clone --depth 1 "$DOWNLOAD_URL" .
fi

# No build step; Python script. Copy to bin folder.
for cmd in "${CUSTOM_COMMANDS[@]}"; do
  echo "[INFO] Running custom command: $cmd"
  eval "$cmd"
done

#===============================================================================
# SECTION 6: POST-INSTALLATION ENVIRONMENT SETUP
#===============================================================================
PROFILE_FILE="$HOME/.zshrc"  # Adjust as necessary
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "${PROFILE_FILE}"
  export PATH="$HOME/.local/bin:$PATH"
fi

#===============================================================================
# SECTION 7: VERIFICATION
#===============================================================================
echo "[INFO] Verifying installation..."
if command -v "$APP_NAME" &>/dev/null; then
  "$APP_NAME" -h
else
  if [ -f "$BIN_PATH" ]; then
    "$BIN_PATH" -h
  else
    echo "[WARN] $APP_NAME not found in PATH."
  fi
fi

#===============================================================================
# SECTION 8: CLEANUP (Optional)
#===============================================================================
echo "[INFO] Cleaning up temporary files..."
rm -rf "/tmp/$APP_NAME"

echo "[SUCCESS] $APP_NAME installed and configured successfully."
echo "Reload shell or run: source ${PROFILE_FILE} to apply environment changes."

