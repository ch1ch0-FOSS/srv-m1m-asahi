#!/usr/bin/env bash
#===============================================================================
#  Application Installation Template - Reusable, Modular, and Interactive
#===============================================================================
#  Author        : ch1ch0
#  Date          : (YYYY-MM-DD*)
#  Environment   : Fedora Asahi Remix 41 ARM64
#  Target System : ch1ch0@asahi-m1m
#-------------------------------------------------------------------------------
#  Purpose       : Install and configure <Application Name> consistently
#  Notes         : Industry professional skeleton; prompts data, confirms, runs
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES (Default placeholders; Edit per install)
#===============================================================================
APP_NAME="<application-name>"           # Example: helix
APP_VERSION="<version>"                 # Example: 1.0.0 or git hash
PKG_MANAGER="<apt|dnf|yum|zypper|pacman>" # Package manager to use
INSTALL_DIR="<install-dir>"             # Example: /opt/${APP_NAME} or ~/git/clones/${APP_NAME}
CONFIG_DIR="<config-dir>"               # Example: /etc/${APP_NAME} or ~/.config/${APP_NAME}
BIN_PATH="<binary-path>"                # Full path to executable after install
DOWNLOAD_URL="<url-to-source-or-archive>" # Optional, if applicable
DEPENDENCIES=()                        # Example: (git gcc cargo cmake tree-sitter-devel)
CUSTOM_COMMANDS=()                      # Optional additional commands array for install steps

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
# SECTION 5: INSTALLATION STEPS (Adjust as needed)
#===============================================================================
echo "[INFO] Running installation steps..."
# Example steps for git clone + build
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "[INFO] Repository exists, pulling latest changes..."
  git pull
else
  echo "[INFO] Cloning repository..."
  git clone --depth 1 "$DOWNLOAD_URL" .
fi

echo "[INFO] Building application (example using cargo)..."
RUSTFLAGS="-C target-cpu=native" cargo install --locked --path helix-term --force --profile opt

# Run any extra custom commands if defined
for cmd in "${CUSTOM_COMMANDS[@]}"; do
  echo "[INFO] Running custom command: $cmd"
  eval "$cmd"
done

#===============================================================================
# SECTION 6: POST-INSTALLATION ENVIRONMENT SETUP
#===============================================================================
PROFILE_FILE="$HOME/.zshrc"  # Adjust as necessary
if ! echo "$PATH" | grep -q "$(dirname "$BIN_PATH")"; then
  echo "export PATH=\"$(dirname "$BIN_PATH"):\$PATH\"" >> "${PROFILE_FILE}"
  export PATH="$(dirname "$BIN_PATH"):$PATH"
fi

echo "[INFO] Setting environment variables..."

if ! grep -q "HELIX_RUNTIME" "${PROFILE_FILE}" && [ -n "$INSTALL_DIR" ]; then
  echo "export HELIX_RUNTIME=\"${INSTALL_DIR}/runtime\"" >> "${PROFILE_FILE}"
  export HELIX_RUNTIME="${INSTALL_DIR}/runtime"
fi

#===============================================================================
# SECTION 7: VERIFICATION
#===============================================================================
echo "[INFO] Verifying installation..."
if command -v "$APP_NAME" &>/dev/null; then
  "$APP_NAME" --version
else
  echo "[WARN] $APP_NAME not found in PATH."
fi

#===============================================================================
# SECTION 8: CLEANUP (Optional)
#===============================================================================
echo "[INFO] Cleaning up temporary files..."
rm -rf "/tmp/$APP_NAME"

echo "[SUCCESS] $APP_NAME installed and configured successfully."
echo "Reload shell or run: source ${PROFILE_FILE} to apply environment changes."

