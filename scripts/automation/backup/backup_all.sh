#!/usr/bin/env bash
# /mnt/data/scripts/backup_all.sh
set -euo pipefail
LOG="/mnt/data/logs/changelog.md"
STAMP="$(date -Is)"
echo "## ${STAMP} Backup run (Forgejo + Nextcloud)" >> "${LOG}"

if /mnt/data/scripts/backup_forgejo_dump.sh >> "${LOG}" 2>&1; then
  echo "- Forgejo dump: OK" >> "${LOG}"
else
  echo "- Forgejo dump: FAIL" >> "${LOG}"
fi

if /mnt/data/scripts/backup_nextcloud.sh >> "${LOG}" 2>&1; then
  echo "- Nextcloud backup: OK" >> "${LOG}"
else
  echo "- Nextcloud backup: FAIL" >> "${LOG}"
fi

echo "" >> "${LOG}"
