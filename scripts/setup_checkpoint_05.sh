#!/bin/bash
# Setup script for sysadmin editors with primary focus on Neovim (nvim) for Fedora Asahi Remix

LOG="/var/log/admin_sudo_priv.log"
USERS=("admin" "ch1ch0")
ADMIN_GROUPS=("wheel")
CORE_UTILS=("sudo" "usermod")
EDITOR_UTILS=("neovim")   # Only nvim (neovim); can add others as needed

echo "[$(date)] Starting sudo/group configuration..." | tee -a "$LOG"

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (try: sudo ./setup_sudo_priv.sh)" | tee -a "$LOG"
  exit 1
fi

# 1. Ensure core system/admin utilities are installed
for pkg in "${CORE_UTILS[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        echo "Installing $pkg..." | tee -a "$LOG"
        dnf install -y "$pkg" | tee -a "$LOG"
    else
        echo "$pkg already installed." | tee -a "$LOG"
    fi
done

# 2. Ensure Neovim is installed (remove vim if not wanted)
for pkg in "${EDITOR_UTILS[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        echo "Installing $pkg..." | tee -a "$LOG"
        dnf install -y "$pkg" | tee -a "$LOG"
    else
        echo "$pkg already installed." | tee -a "$LOG"
    fi
done

# Optional: Remove vim if you do not want it at all
if rpm -q vim-enhanced &>/dev/null; then
    echo "Removing vim-enhanced (per nvim standardization)..." | tee -a "$LOG"
    dnf remove -y vim-enhanced | tee -a "$LOG"
fi

# 3. Add users to admin groups (wheel)
for user in "${USERS[@]}"; do
    echo "Adding $user to wheel..." | tee -a "$LOG"
    usermod -aG wheel "$user" 2>&1 | tee -a "$LOG"
done

# 4. Sudoers configuration (unchanged)
echo "Configuring /etc/sudoers.d/sysadmin_custom..." | tee -a "$LOG"
(
    echo "# Project-specific sudoers for sysadmin users"
    for user in "${USERS[@]}"; do
        echo "$user ALL=(ALL:ALL) ALL"
    done
) > /etc/sudoers.d/sysadmin_custom

chmod 440 /etc/sudoers.d/sysadmin_custom
visudo -cf /etc/sudoers.d/sysadmin_custom | tee -a "$LOG"

echo "[$(date)] Sudo and group setup complete." | tee -a "$LOG"
