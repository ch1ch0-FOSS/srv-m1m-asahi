#!/usr/bin/env bash
#===============================================================================
#  Forgejo Backup Script – Daily Automated Backups
#===============================================================================
#  Author        : ch1ch0
#  Date          : 2025-11-07
#  Environment   : Fedora Asahi Remix 42 ARM64
#  Target System : Fedora Linux (aarch64)
#-------------------------------------------------------------------------------
#  Purpose       : Automated daily backup of Forgejo Git server
#  Frequency     : Runs daily via systemd timer at 02:30 AM
#  Location      : /usr/local/bin/backup-forgejo.sh
#  Data Backup   : /mnt/data/backups/
#  Retention     : Last 7 days (automatic pruning)
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================
BACKUP_DIR="/mnt/data/backups"
FORGEJO_USER="git"
FORGEJO_CONFIG="/etc/forgejo/app.ini"
FORGEJO_DATA_DIR="/mnt/data/srv/forgejo"
BACKUP_DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="forgejo-backup-${BACKUP_DATE}"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"
RETENTION_DAYS=7
LOG_FILE="${BACKUP_DIR}/backup.log"

#===============================================================================
# SECTION 2: LOGGING SETUP
#===============================================================================
log() {
  local level=$1
  shift
  local message="$@"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[${timestamp}] [${level}] ${message}" | tee -a "$LOG_FILE"
}

#===============================================================================
# SECTION 3: PRE-BACKUP VERIFICATION
#===============================================================================
log "INFO" "========== FORGEJO BACKUP START =========="
log "INFO" "Backup date: $BACKUP_DATE"
log "INFO" "Backup path: $BACKUP_PATH"

# Verify Forgejo config exists
if [ ! -f "$FORGEJO_CONFIG" ]; then
  log "ERROR" "Forgejo config not found: $FORGEJO_CONFIG"
  exit 1
fi

# Verify Forgejo data directory exists
if [ ! -d "$FORGEJO_DATA_DIR" ]; then
  log "ERROR" "Forgejo data directory not found: $FORGEJO_DATA_DIR"
  exit 1
fi

# Verify backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  log "WARN" "Creating backup directory: $BACKUP_DIR"
  sudo mkdir -p "$BACKUP_DIR"
  sudo chmod 700 "$BACKUP_DIR"
fi

# Check disk space (require at least 5GB free)
AVAILABLE_SPACE=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')
if [ "$AVAILABLE_SPACE" -lt 5242880 ]; then
  log "ERROR" "Insufficient disk space. Available: ${AVAILABLE_SPACE}KB"
  exit 1
fi
log "INFO" "Disk space check passed. Available: $(numfmt --to=iec $((AVAILABLE_SPACE * 1024)))"

#===============================================================================
# SECTION 4: CREATE BACKUP DIRECTORY
#===============================================================================
log "INFO" "Creating backup directory..."
sudo mkdir -p "$BACKUP_PATH"
sudo chmod 700 "$BACKUP_PATH"
log "INFO" "  ✓ Backup directory created"

#===============================================================================
# SECTION 5: DUMP FORGEJO DATABASE & FILES
#===============================================================================
log "INFO" "Dumping Forgejo data..."
log "INFO" "  Exporting database and repositories..."

# Run forgejo dump command (creates .zip file with everything)
sudo -u "$FORGEJO_USER" /usr/bin/forgejo dump \
  -c "$FORGEJO_CONFIG" \
  -o "${BACKUP_PATH}/forgejo-dump.zip" \
  2>&1 | while read line; do log "INFO" "  $line"; done

if [ ! -f "${BACKUP_PATH}/forgejo-dump.zip" ]; then
  log "ERROR" "Failed to create Forgejo dump"
  exit 1
fi

DUMP_SIZE=$(du -h "${BACKUP_PATH}/forgejo-dump.zip" | cut -f1)
log "INFO" "  ✓ Dump created successfully (size: $DUMP_SIZE)"

#===============================================================================
# SECTION 6: BACKUP CONFIGURATION FILES
#===============================================================================
log "INFO" "Backing up configuration files..."

# Backup Forgejo config
sudo cp "$FORGEJO_CONFIG" "${BACKUP_PATH}/app.ini" 2>/dev/null || log "WARN" "Could not copy app.ini"

# Backup systemd unit
sudo cp /etc/systemd/system/forgejo.service "${BACKUP_PATH}/forgejo.service" 2>/dev/null || log "WARN" "Could not copy forgejo.service"

log "INFO" "  ✓ Configuration files backed up"

#===============================================================================
# SECTION 7: CREATE METADATA FILE
#===============================================================================
log "INFO" "Creating backup metadata..."
cat > "${BACKUP_PATH}/BACKUP_METADATA.txt" <<EOF
Forgejo Backup Information
==========================

Backup Date       : $BACKUP_DATE
Backup Location   : $BACKUP_PATH
Hostname          : $(hostname)
System            : $(uname -a)

Forgejo Details
===============
Config File       : $FORGEJO_CONFIG
Data Directory    : $FORGEJO_DATA_DIR
Service User      : $FORGEJO_USER

Backup Contents
===============
- forgejo-dump.zip      : Complete Forgejo database & repositories
- app.ini               : Forgejo configuration (for reference)
- forgejo.service       : Systemd unit file (for reference)
- BACKUP_METADATA.txt   : This file

Recovery Instructions
======================
1. Extract forgejo-dump.zip to temporary location
2. Restore from Forgejo restore command:
   sudo -u git /usr/bin/forgejo restore --file <extracted-file>
3. Restart Forgejo: sudo systemctl restart forgejo

Backup Hash
===========
Created by: backup-forgejo.sh
Version: 1.0
EOF

log "INFO" "  ✓ Metadata file created"

#===============================================================================
# SECTION 8: VERIFY BACKUP INTEGRITY
#===============================================================================
log "INFO" "Verifying backup integrity..."

# Check if zip file is valid
if ! sudo unzip -t "${BACKUP_PATH}/forgejo-dump.zip" &>/dev/null; then
  log "ERROR" "Backup zip file is corrupted"
  exit 1
fi
log "INFO" "  ✓ Zip integrity verified"

# Check backup size
TOTAL_BACKUP_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
log "INFO" "  ✓ Total backup size: $TOTAL_BACKUP_SIZE"

#===============================================================================
# SECTION 9: CLEANUP OLD BACKUPS
#===============================================================================
log "INFO" "Cleaning up old backups (keeping last $RETENTION_DAYS days)..."
find "$BACKUP_DIR" -maxdepth 1 -type d -name "forgejo-backup-*" -mtime +$RETENTION_DAYS | while read old_backup; do
  log "INFO" "  Removing old backup: $old_backup"
  sudo rm -rf "$old_backup"
done
log "INFO" "  ✓ Old backups cleaned up"

#===============================================================================
# SECTION 10: POST-BACKUP SUMMARY
#===============================================================================
BACKUP_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "forgejo-backup-*" | wc -l)
log "INFO" "========== BACKUP SUMMARY =========="
log "INFO" "Backup Status      : ✓ SUCCESS"
log "INFO" "Backup Name        : $BACKUP_NAME"
log "INFO" "Backup Size        : $TOTAL_BACKUP_SIZE"
log "INFO" "Backups Retained   : $BACKUP_COUNT (last $RETENTION_DAYS days)"
log "INFO" "Log File           : $LOG_FILE"
log "INFO" "===================================="
log "INFO" "========== FORGEJO BACKUP COMPLETE =========="

#===============================================================================
# SECTION 11: ALERT ON FAILURE (Optional – can be configured)
#===============================================================================
# Uncomment to enable email alerts
# if [ $? -ne 0 ]; then
#   echo "Forgejo backup failed on $(hostname)" | \
#     mail -s "Backup Error: $(hostname)" your-email@example.com
# fi

exit 0