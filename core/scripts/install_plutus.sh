#!/usr/bin/env bash
#===============================================================================
#  Ollama Model Installation - Plutus (Finance-Focused LLM)
#===============================================================================
#  Author        : ch1ch0
#  Date          : 2025-10-18
#  Environment   : Fedora Asahi Remix 41 ARM64
#  Target System : Multi-user trading system
#-------------------------------------------------------------------------------
#  Purpose       : Install Plutus model for financial analysis and trading
#  Model Info    : LLaMA-3.1-8B fine-tuned for finance (5.7GB, 128K context)
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================
APP_NAME="ollama-plutus"
MODEL_NAME="0xroyce/plutus"
MODEL_TAG="latest"
MODEL_SIZE="5.7GB"
PKG_MANAGER="dnf"
SHARED_MODELS_DIR="/mnt/data/shared/ollama/models"
OLLAMA_SERVICE_CONFIG="/etc/systemd/system/ollama.service.d/override.conf"
DEPENDENCIES=("ollama")

#===============================================================================
# SECTION 2: USER INPUT TO OVERRIDE DEFAULTS
#===============================================================================
echo "==================================================================="
echo "  Ollama Plutus Model Installation"
echo "==================================================================="
echo
echo "This will install the Plutus model (${MODEL_SIZE})"
echo "Plutus is optimized for finance, economics, trading, and psychology"
echo

read -rp "Model name [${MODEL_NAME}]: " input_model_name
MODEL_NAME=${input_model_name:-$MODEL_NAME}

read -rp "Model tag [${MODEL_TAG}]: " input_model_tag
MODEL_TAG=${input_model_tag:-$MODEL_TAG}

read -rp "Shared models directory [${SHARED_MODELS_DIR}]: " input_models_dir
SHARED_MODELS_DIR=${input_models_dir:-$SHARED_MODELS_DIR}

#===============================================================================
# SECTION 3: CONFIRMATION BEFORE RUNNING
#===============================================================================
echo
echo "Please confirm installation configuration:"
echo "  Model Name            : ${MODEL_NAME}"
echo "  Model Tag             : ${MODEL_TAG}"
echo "  Approximate Size      : ${MODEL_SIZE}"
echo "  Shared Models Dir     : ${SHARED_MODELS_DIR}"
echo "  Package Manager       : ${PKG_MANAGER}"
echo

read -rp "Proceed with installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Installation aborted."
  exit 1
fi

#===============================================================================
# SECTION 4: CHECK AND INSTALL DEPENDENCIES
#===============================================================================
echo "[INFO] Checking if Ollama is installed..."
if ! command -v ollama &>/dev/null; then
  echo "[INFO] Ollama not found. Installing Ollama..."
  case "$PKG_MANAGER" in
    dnf)
      # Install via official script
      curl -fsSL https://ollama.com/install.sh | sudo sh
      ;;
    *)
      echo "[ERROR] Unsupported package manager: $PKG_MANAGER"
      exit 1
      ;;
  esac
else
  echo "[INFO] Ollama is already installed."
  ollama --version
fi

#===============================================================================
# SECTION 5: CREATE SHARED MODELS DIRECTORY
#===============================================================================
echo "[INFO] Creating shared models directory..."
sudo mkdir -p "${SHARED_MODELS_DIR}"

# Set ownership to ollama user/group (created during Ollama installation)
echo "[INFO] Setting ownership and permissions..."
sudo chown -R ollama:ollama "${SHARED_MODELS_DIR}"
sudo chmod -R 775 "${SHARED_MODELS_DIR}"

# Add current user and admin to ollama group for access
echo "[INFO] Adding users to ollama group..."
sudo usermod -a -G ollama admin
sudo usermod -a -G ollama trading
sudo usermod -a -G ollama "$(whoami)" 2>/dev/null || true

#===============================================================================
# SECTION 6: CONFIGURE OLLAMA SYSTEMD SERVICE
#===============================================================================
echo "[INFO] Configuring Ollama systemd service..."

# Create systemd override directory
sudo mkdir -p /etc/systemd/system/ollama.service.d/

# Create override configuration
cat <<EOF | sudo tee "${OLLAMA_SERVICE_CONFIG}" >/dev/null
[Service]
# Custom model storage location
Environment="OLLAMA_MODELS=${SHARED_MODELS_DIR}"

# Optional: Bind to all interfaces for network access
# Environment="OLLAMA_HOST=0.0.0.0:11434"

# Optional: Keep models loaded longer (default 5m)
Environment="OLLAMA_KEEP_ALIVE=30m"

# Optional: Enable debug logging
# Environment="OLLAMA_DEBUG=1"
EOF

echo "[INFO] Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "[INFO] Restarting Ollama service..."
sudo systemctl restart ollama

echo "[INFO] Enabling Ollama service to start on boot..."
sudo systemctl enable ollama

# Verify service status
echo "[INFO] Checking Ollama service status..."
sudo systemctl status ollama --no-pager || true

#===============================================================================
# SECTION 7: PULL THE MODEL
#===============================================================================
echo "[INFO] Pulling ${MODEL_NAME}:${MODEL_TAG} model..."
echo "[INFO] This may take several minutes depending on your connection..."

if [ -n "${MODEL_TAG}" ] && [ "${MODEL_TAG}" != "latest" ]; then
  ollama pull "${MODEL_NAME}:${MODEL_TAG}"
else
  ollama pull "${MODEL_NAME}"
fi

#===============================================================================
# SECTION 8: VERIFICATION
#===============================================================================
echo "[INFO] Verifying installation..."
echo "[INFO] Listing installed models:"
ollama list

echo "[INFO] Checking model storage location:"
ls -lah "${SHARED_MODELS_DIR}"

#===============================================================================
# SECTION 9: POST-INSTALLATION NOTES
#===============================================================================
echo
echo "==================================================================="
echo "[SUCCESS] Plutus model installed successfully!"
echo "==================================================================="
echo
echo "Usage Examples:"
echo "  1. Run interactive session:"
echo "     ollama run ${MODEL_NAME}"
echo
echo "  2. Single query:"
echo "     ollama run ${MODEL_NAME} \"Explain the efficient market hypothesis\""
echo
echo "  3. API access (if OLLAMA_HOST configured):"
echo "     curl http://localhost:11434/api/generate -d '{"
echo "       \"model\": \"${MODEL_NAME}\","
echo "       \"prompt\": \"What are key trading indicators?\""
echo "     }'"
echo
echo "Model Location: ${SHARED_MODELS_DIR}"
echo
echo "IMPORTANT: You may need to log out and back in for group changes to take effect."
echo "Or run: newgrp ollama"
echo
</parameter>
</invoke>

