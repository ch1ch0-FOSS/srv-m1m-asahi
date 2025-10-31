# Log file setup (auto-naming by date and script)
LOG_DIR="${HOME}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)_$(date +%Y-%m-%d_%H-%M-%S).log"

# Redirect all stdout/stderr to log (still shows in terminal)
exec > >(tee -a "$LOG_FILE") 2>&1

# Example log start marker
echo "=== $(basename "$0") started at $(date) ==="
