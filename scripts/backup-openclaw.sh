#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${1:-$HOME/.openclaw/workspace}"
cd "$REPO_DIR"

# Ensure git repo exists
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[backup] Not a git repository: $REPO_DIR" >&2
  exit 1
fi

# Stage safe files only (respecting .gitignore)
git add -A

if git diff --cached --quiet; then
  echo "[backup] No changes to commit"
  exit 0
fi

stamp="$(date '+%Y-%m-%d %H:%M:%S %z')"
git commit -m "backup: $stamp"

echo "[backup] Commit created"

# Push only when a remote is configured
if git remote get-url origin >/dev/null 2>&1; then
  branch="$(git rev-parse --abbrev-ref HEAD)"
  git push -u origin "$branch"
  echo "[backup] Pushed to origin/$branch"
else
  echo "[backup] No remote 'origin' configured; skipped push"
fi
