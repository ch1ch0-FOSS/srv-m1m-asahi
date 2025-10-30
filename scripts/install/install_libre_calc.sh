#!/usr/bin/env bash
# ===============================================================
#  Script Name : install_libre_calc.sh
#  Author      : ch1ch0
#  Created     : 2025-10-24
#  Project     : srv-m1m-asahi (Public Admin Portfolio)
# ---------------------------------------------------------------
#  Purpose:
#    Automate installation of LibreOffice Calc on Fedora systems.
#    Demonstrates practical Linux scripting and automation design
#    for use in workstation or professional admin contexts.
#
#  Usage:
#    chmod +x install_libre_calc.sh
#    ./install_libre_calc.sh
#
#  Notes:
#    - Designed for Fedora Asahi variant but compatible with other
#      Fedora-based distributions.
#    - Installs only the Calc component, not the entire office suite.
#    - Safe to run multiple times (idempotent install).
#
# ===============================================================

set -e  # Exit on first failure
set -u  # Treat unset variables as errors
set -o pipefail

echo "=== LibreOffice Calc Installation Script ==="

# Update and prepare system packages
echo "[1/3] Refreshing package indexes..."
sudo dnf clean all -y
sudo dnf -y update

# Install LibreOffice Calc
echo "[2/3] Installing LibreOffice Calc..."
sudo dnf install -y libreoffice-calc

# Verify installation
echo "[3/3] Verifying installation..."
if command -v libreoffice &>/dev/null; then
    echo
    echo "✅ LibreOffice Calc installed successfully!"
    libreoffice --calc --version
else
    echo
    echo "❌ Installation failed or LibreOffice not detected."
    exit 1
fi

echo
echo "--- Installation Procedure Complete ---"
echo "You can now launch LibreOffice Calc via your application menu"
echo "or by running: libreoffice --calc"

