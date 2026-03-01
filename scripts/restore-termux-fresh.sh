#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

REPO_URL="${1:-https://github.com/HoanNguyen0212/mimi-openclaw-backup.git}"
WORKSPACE_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
JOB_NAME="workspace-git-backup"

pkg update -y
pkg install -y git gh nodejs-lts
command -v openclaw >/dev/null 2>&1 || npm install -g openclaw@latest

gh auth status -h github.com >/dev/null 2>&1 || gh auth login -h github.com -p https -s repo,workflow --web
gh auth setup-git

if [ -d "$WORKSPACE_DIR/.git" ]; then
  git -C "$WORKSPACE_DIR" pull --rebase
else
  mkdir -p "$(dirname "$WORKSPACE_DIR")"
  git clone "$REPO_URL" "$WORKSPACE_DIR"
fi

chmod +x "$WORKSPACE_DIR"/scripts/*.sh || true
openclaw setup --workspace "$WORKSPACE_DIR"

if ! openclaw cron list | grep -q "$JOB_NAME"; then
  openclaw cron add \
    --name "$JOB_NAME" \
    --every 6h \
    --session isolated \
    --no-deliver \
    --message "Run this command exactly and return only exit status + short output: bash $WORKSPACE_DIR/scripts/backup-openclaw.sh $WORKSPACE_DIR"
fi

openclaw gateway restart || openclaw gateway start || true

echo "[restore] Done"
