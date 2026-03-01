#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

REPO_DIR="$HOME/.openclaw/workspace"
BACKUP_SCRIPT="$REPO_DIR/scripts/backup-openclaw.sh"

cd "$REPO_DIR"

# Skip quietly until GitHub auth is ready
if ! gh auth status -h github.com >/dev/null 2>&1; then
  echo "[auto-backup] gh not authenticated; skipping"
  exit 0
fi

"$BACKUP_SCRIPT" "$REPO_DIR"
