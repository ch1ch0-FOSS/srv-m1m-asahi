#!/bin/bash
# ================================================================
# Script Name: checkpoint_automation_jobtracker.sh
# Checkpoint: 34 — Job Tracker Automation Integration
# Purpose: Automate job tracking pipeline between Markdown and CSV;
#          generate conversion logs and ensure continuous workflow documentation.
# Usage: ./checkpoint_automation_jobtracker.sh
# Arguments: None
# Outputs:  - Convert job-tracker-v2.md → job-tracker-v2.csv
#           - Verify LibreOffice presence
#           - Emit formatted logs and telemetry
# Dependencies: awk, column, tee, libreoffice-calc (optional)
# Maintainer: Devin M. Castille (ch1ch0)
# Last Modified: 2025-10-24
# ================================================================

# --- Logging Setup ---
LOG_DIR="${HOME}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)_$(date +%Y-%m-%d_%H-%M-%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== $(basename "$0") started at $(date) ==="

# --- Context Setup ---
SRC_MD="$HOME/docs/job_applications/job-tracker-v2.md"
OUT_CSV="$HOME/docs/job_applications/job-tracker-v2.csv"

echo "Source tracker: $SRC_MD"
echo "Output CSV:     $OUT_CSV"
echo "Logging to:     $LOG_FILE"
echo

# --- Step 1: Input Validation ---
if [ ! -f "$SRC_MD" ]; then
    echo "[ERROR] Missing source Markdown file: $SRC_MD"
    exit 1
fi

# --- Step 2: Convert Markdown → CSV ---
echo "[INFO] Converting job tracker Markdown to CSV..."
awk -F'|' '
/^ *\|/ && !/^ *\| *[-:]/ {
    gsub(/^[ \t]*\|[ \t]*/, "", $0);
    gsub(/[ \t]*\|[ \t]*$/, "", $0);
    gsub(/[ \t]*\|[ \t]*/, ",", $0);
    print $0
}' "$SRC_MD" > "$OUT_CSV"

if [ $? -eq 0 ]; then
    echo "[SUCCESS] CSV successfully generated: $OUT_CSV"
else
    echo "[FAILURE] CSV generation failed."
    exit 2
fi

# --- Step 3: Verify LibreOffice Install ---
if ! command -v libreoffice &>/dev/null; then
    echo "[WARN] LibreOffice not installed — CLI visualization only."
    echo "[INFO] You can open via column mode:"
    echo "       column -t -s, $OUT_CSV | less -S"
else
    echo "[INFO] LibreOffice detected. Opening CSV in Calc..."
    libreoffice --calc "$OUT_CSV" &
fi

# --- Step 4: Automated Summary Output ---
echo
echo "[INFO] Generating quick application summary..."
APPLIED=$(grep -o "📩" "$SRC_MD" | wc -l)
INTERVIEWS=$(grep -o "📞" "$SRC_MD" | wc -l)
DENIED=$(grep -o "❌" "$SRC_MD" | wc -l)
OFFERS=$(grep -o "✅" "$SRC_MD" | wc -l)

printf "📊 Summary (as of %s)\n" "$(date)"
printf "   Applied:   %d\n" "$APPLIED"
printf "   Interviews:%d\n" "$INTERVIEWS"
printf "   Denied:    %d\n" "$DENIED"
printf "   Offers:    %d\n" "$OFFERS"
echo

# --- Step 5: Version Control Commit ---
cd "$HOME/docs/job_applications/" || exit
if git rev-parse --git-dir &>/dev/null; then
    echo "[INFO] Git repository detected. Committing changes..."
    git add job-tracker-v2.*
    git commit -m "Checkpoint 34: Job tracker automation & CSV update"
    git push origin main
else
    echo "[INFO] No Git repo found — skipping commit stage."
fi

echo "=== $(basename "$0") completed successfully at $(date) ==="
exit 0

