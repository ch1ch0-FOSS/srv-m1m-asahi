#!/usr/bin/env bash
#===============================================================================
#  Ollama Model Installation - Nomic Embed Text (Embedding Model)
#===============================================================================
#  Author        : ch1ch0
#  Date          : 2025-10-18
#  Environment   : Fedora Asahi Remix 41 ARM64
#  Target System : Multi-user environment (admin/trading)
#-------------------------------------------------------------------------------
#  Purpose       : Install Nomic Embed Text model for text embedding generation
#  Model Info    : nomic-embed-text (137M params, 2K context, embedding-only)
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================
APP_NAME="ollama-nomic-embed-text"
MODEL_NAME="nomic-embed-text"
MODEL_TAG="latest"
MODEL_SIZE="274MB"
PKG_MANAGER="dnf"
SHARED_MODELS_DIR="/mnt/data/shared/ollama/models"
OLLAMA_SERVICE_CONFIG="/etc/systemd/system/ollama.service.d/override.conf"
DEPENDENCIES=("ollama")

#===============================================================================
# SECTION 2: USER INPUT TO OVERRIDE DEFAULTS
#===============================================================================
echo "==================================================================="
echo "  Ollama Nomic Embed Text Model Installation"
echo "==================================================================="
echo
echo "This installs the Nomic Embed Text model (${MODEL_SIZE})"
echo "Purpose: high-efficiency text embeddings; surpasses OpenAI's ada-002"
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
# SECTION 4: DEPENDENCY CHECK
#===============================================================================
echo "[INFO] Checking if Ollama is installed..."
if ! command -v ollama &>/dev/null; then
  echo "[INFO] Ollama not found. Installing Ollama..."
  case "$PKG_MANAGER" in
    dnf)
      curl -fsSL https://ollama.com/install.sh | sudo sh
      ;;
    *)
      echo "[ERROR] Unsupported package manager: $PKG_MANAGER"
      exit 1
      ;;
  esac
else
  echo "[INFO] Ollama detected."
  ollama --version
fi

#===============================================================================
# SECTION 5: CREATE SHARED MODELS DIRECTORY
#===============================================================================
echo "[INFO] Creating shared models directory if missing..."
sudo mkdir -p "${SHARED_MODELS_DIR}"
sudo chown -R ollama:ollama "${SHARED_MODELS_DIR}"
sudo chmod -R 775 "${SHARED_MODELS_DIR}"

# grant access to both admin and trading users
sudo usermod -a -G ollama admin
sudo usermod -a -G ollama trading
sudo usermod -a -G ollama "$(whoami)" 2>/dev/null || true

#===============================================================================
# SECTION 6: CONFIGURE SYSTEMD SERVICE (OLLAMA_MODELS)
#===============================================================================
echo "[INFO] Configuring Ollama systemd environment override..."
sudo mkdir -p /etc/systemd/system/ollama.service.d/
cat <<EOF | sudo tee "${OLLAMA_SERVICE_CONFIG}" >/dev/null
[Service]
Environment="OLLAMA_MODELS=${SHARED_MODELS_DIR}"
Environment="OLLAMA_KEEP_ALIVE=30m"
# Environment="OLLAMA_DEBUG=1"
EOF

sudo systemctl daemon-reload
sudo systemctl restart ollama
sudo systemctl enable ollama

echo "[INFO] Ollama systemd service updated to use shared models directory."

#===============================================================================
# SECTION 7: PULL MODEL
#===============================================================================
echo "[INFO] Fetching model: ${MODEL_NAME}:${MODEL_TAG}..."
if [ -n "${MODEL_TAG}" ] && [ "${MODEL_TAG}" != "latest" ]; then
  ollama pull "${MODEL_NAME}:${MODEL_TAG}"
else
  ollama pull "${MODEL_NAME}"
fi

#===============================================================================
# SECTION 8: VERIFY INSTALLATION
#===============================================================================
echo "[INFO] Verifying model installation..."
ollama list | grep -E "${MODEL_NAME}" || echo "[WARN] Model not found in list!"
echo "[INFO] Model stored at: ${SHARED_MODELS_DIR}"
ls -lah "${SHARED_MODELS_DIR}"

#===============================================================================
# SECTION 9: FUNCTIONAL TEST
#===============================================================================
echo "[INFO] Running embedding test..."
curl -s http://localhost:11434/api/embeddings -d '{
  "model": "'${MODEL_NAME}'",
  "prompt": "Testing text embedding generation for installation verification"
}' | jq || echo "[WARN] Failed to fetch embedding test result (requires jq, optional)."

#===============================================================================
# SECTION 10: COMPLETION
#===============================================================================
echo
echo "==================================================================="
echo "[SUCCESS] Nomic Embed Text model installed successfully!"
echo "==================================================================="
echo
echo "Usage Examples:"
echo
echo "  REST API:"
echo "    curl http://localhost:11434/api/embeddings -d '{"
echo "      \"model\": \"${MODEL_NAME}\","
echo "      \"prompt\": \"The sky is blue because of Rayleigh scattering\""
echo "    }'"
echo
echo "  Python API:"
echo "    ollama.embeddings(model='${MODEL_NAME}', prompt='example sentence')"
echo
echo "  CLI verification:"
echo "    ollama run ${MODEL_NAME}"
echo
echo "Shared Model Path: ${SHARED_MODELS_DIR}"
echo "Apply group changes with: newgrp ollama"
echo

