#!/bin/bash
# Script Name: setup_trading_user_openbb_ollama.sh
# Checkpoint: Trading User Setup — OpenBB + Ollama + Xfce Minimal GUI (Fedora Asahi)
# Purpose: Provision 'trading' user, install minimal Xfce GUI, OpenBB, and Ollama (with model); configure for secure, logged workflow.
# Usage: sudo ./setup_trading_user_openbb_ollama.sh
# Arguments: None
# Outputs: Logs, install/config status, verification steps
# Dependencies: Fedora Asahi, sudo privileges, wget/curl, systemd, internet access
# Maintainer: ch1ch0
# Last Modified: 2025-10-07

# --- Logging Setup ---
LOG_DIR="/var/log/setup_logs"
sudo mkdir -p "$LOG_DIR"
sudo chmod 777 "$LOG_DIR"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)_$(date +%Y-%m-%d_%H-%M-%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== $(basename "$0") started at $(date) ==="

# --- Configuration ---
TRADING_USER="trading"
TRADING_HOME="/home/$TRADING_USER"

# --- 1. Create Trading User ---
if ! id "$TRADING_USER" &>/dev/null; then
    echo "[Step] Creating user: $TRADING_USER"
    sudo useradd -m -s /bin/bash "$TRADING_USER"
    sudo passwd -l "$TRADING_USER" # lock password to prevent direct login (adjust policy as needed)
    sudo usermod -aG wheel "$TRADING_USER" # add to 'wheel' if admin access is desired
else
    echo "[Info] User $TRADING_USER already exists."
fi

# --- 2. Install Minimal GUI (Xfce) ---
echo "[Step] Installing minimal Xfce GUI (Fedora)"
sudo dnf groupinstall -y 'Xfce Desktop'
sudo dnf install -y @xfce-desktop-environment xorg-x11-server-Xorg dbus-x11

# --- 3. Install OpenBB (as trading user) ---
echo "[Step] Installing OpenBB Terminal for trading user"
sudo -u "$TRADING_USER" bash -c "cd ~ && curl -sSL https://openbb.co/install.sh | bash"

# --- 4. Install Ollama ---
echo "[Step] Installing Ollama"
curl -fsSL https://ollama.com/install.sh | sudo bash

# --- 5. Add trading user to ollama group if required ---
# Ollama installer usually handles group membership automatically. If not, do:
if getent group ollama >/dev/null; then
    sudo usermod -aG ollama "$TRADING_USER"
else
    echo "[Info] ollama group does not exist or not needed."
fi

# --- 6. Start/enable Ollama service ---
echo "[Step] Enabling and starting Ollama systemd service"
sudo systemctl enable --now ollama

# --- 7. Download stock-focused Ollama model as trading user ---
echo "[Step] Downloading stock-focused Ollama model (trading user, CPU mode)"
sudo -u "$TRADING_USER" ollama pull llama2:latest # replace with stock/finance-focused model if available

# --- 8. Verification Steps ---
echo "[$(date)] Completed installation and baseline config." | tee -a "$LOG_FILE"
echo "[Verify] Check GUI: run 'startxfce4' from trading user or verify graphical.target"
echo "[Verify] Switch to trading user: sudo -i -u trading"
echo "[Verify] Test OpenBB: openbb"
echo "[Verify] Test Ollama: ollama list"

echo "=== $(basename "$0") ended at $(date) ==="
