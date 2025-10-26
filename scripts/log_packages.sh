#!/bin/bash
# Save a snapshot of all explicitly installed packages for audit/tracking

DATE=$(date +%Y-%m-%d_%H-%M-%S)
OUTDIR="$HOME/logs/package_audits"
OUTFILE="$OUTDIR/installed_packages_$DATE.txt"

mkdir -p "$OUTDIR"

# List user-installed RPMs (not dependencies)
dnf repoquery --qf "%{name}" --userinstalled > "$OUTFILE"

# (Optional) Also append package list to your SYSTEM_SETUP.md (one snapshot per checkpoint)
echo -e "
## Package List Snapshot ($DATE):
" >> $HOME/SYSTEM_SETUP.md
cat "$OUTFILE" >> $HOME/SYSTEM_SETUP.md

echo "Package list saved to $OUTFILE and appended to SYSTEM_SETUP.md."
