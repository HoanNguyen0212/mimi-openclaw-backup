#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Restore OpenClaw workspace backup on a fresh Termux install.
# This script restores workspace files (memory/persona), not ~/.openclaw credentials/sessions.

REPO_URL="${1:-https://github.com/HoanNguyen0212/mimi-openclaw-backup.git}"
WORKSPACE_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
JOB_NAME="workspace-git-backup"

log() { echo "[restore] $*"; }

log "Installing required packages (git, gh, nodejs-lts)..."
pkg update -y
pkg install -y git gh nodejs-lts

if ! command -v openclaw >/dev/null 2>&1; then
  log "Installing OpenClaw CLI..."
  npm install -g openclaw@latest
fi

log "GitHub login (browser/device flow may open)"
if ! gh auth status -h github.com >/dev/null 2>&1; then
  gh auth login -h github.com -p https -s repo,workflow --web
fi

gh auth setup-git

if [ -d "$WORKSPACE_DIR/.git" ]; then
  log "Workspace repo exists -> pulling latest"
  git -C "$WORKSPACE_DIR" pull --rebase
else
  log "Cloning backup repo to $WORKSPACE_DIR"
  mkdir -p "$(dirname "$WORKSPACE_DIR")"
  git clone "$REPO_URL" "$WORKSPACE_DIR"
fi

log "Making scripts executable"
chmod +x "$WORKSPACE_DIR"/scripts/*.sh || true

log "Running OpenClaw setup with restored workspace"
openclaw setup --workspace "$WORKSPACE_DIR"

# Ensure periodic backup cron exists
if openclaw cron list | grep -q "$JOB_NAME"; then
  log "Cron '$JOB_NAME' already exists"
else
  log "Creating cron '$JOB_NAME' (every 6h, isolated, no delivery)"
  openclaw cron add \
    --name "$JOB_NAME" \
    --every 6h \
    --session isolated \
    --no-deliver \
    --message "Run this command exactly and return only exit status + short output: bash $WORKSPACE_DIR/scripts/backup-openclaw.sh $WORKSPACE_DIR"
fi

log "Restarting gateway"
openclaw gateway restart || openclaw gateway start || true

log "Done. Verify with: openclaw cron list && openclaw cron runs --limit 3"
