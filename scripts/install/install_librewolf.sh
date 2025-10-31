#!/usr/bin/env bash
# ===============================================================
#  Script Name : install_librewolf.sh
#  Author      : ch1ch0
#  Created     : 2025-10-24
#  Project     : srv-m1m-asahi (Public Admin Portfolio)
# ---------------------------------------------------------------
#  Purpose:
#    Automate installation of LibreWolf – a privacy‑focused,
#    open‑source browser derived from Mozilla Firefox.
#    Designed for Fedora‑based environments and Fedora Asahi ARM64.
#
#  Usage:
#    chmod +x install_librewolf.sh
#    ./install_librewolf.sh
#
#  Notes:
#    - Installs LibreWolf from its official COPR repository.
#    - Verifies presence of 'librewolf' executable.
#    - Can be safely re‑run; supports idempotent deployment.
#
# ===============================================================

set -e
set -u
set -o pipefail

echo "=== LibreWolf Installation Script ==="

# ---------------------------------------------------------------
# [1/4] Update repositories and system packages
# ---------------------------------------------------------------
echo "[1/4] Updating system package indexes..."
sudo dnf clean all -y
sudo dnf -y update

# ---------------------------------------------------------------
# [2/4] Enable official LibreWolf COPR repository
# ---------------------------------------------------------------
echo "[2/4] Enabling LibreWolf COPR..."
# Fedora COPR maintained by LibreWolf Project
sudo dnf install -y dnf-plugins-core
sudo dnf copr enable tuxino/librewolf -y

# ---------------------------------------------------------------
# [3/4] Install LibreWolf
# ---------------------------------------------------------------
echo "[3/4] Installing LibreWolf browser..."
sudo dnf install -y librewolf

# ---------------------------------------------------------------
# [4/4] Verify installation
# ---------------------------------------------------------------
echo "[4/4] Verifying installation..."
if command -v librewolf &>/dev/null; then
    echo
    echo "✅ LibreWolf installed successfully!"
    librewolf --version || echo "Version check: GUI‑only environment."
else
    echo
    echo "❌ Installation failed or 'librewolf' not found."
    exit 1
fi

echo
echo "--- Installation Complete ---"
echo "Launch via your application menu or run: librewolf"

