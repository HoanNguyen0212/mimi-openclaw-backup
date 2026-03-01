#!/usr/bin/env bash
set -euo pipefail

# Quick rollback for ~/.openclaw/workspace git repo
# Usage:
#   rollback-openclaw.sh <ref> [--push]
# Example:
#   rollback-openclaw.sh HEAD~1 --push

REPO_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
REF="${1:-}"
PUSH="${2:-}"

if [ -z "$REF" ]; then
  echo "Usage: $0 <ref> [--push]" >&2
  exit 1
fi

cd "$REPO_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[rollback] Not a git repository: $REPO_DIR" >&2
  exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "[rollback] Working tree has uncommitted changes. Commit/stash first." >&2
  exit 1
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$current_branch" != "main" ]; then
  echo "[rollback] Warning: current branch is '$current_branch' (expected 'main')."
fi

# Safety snapshot before rollback
stamp="$(date +'%Y%m%d-%H%M%S')"
safety_tag="pre-rollback-${stamp}"
git tag "$safety_tag"
echo "[rollback] Safety tag created: $safety_tag"

# Ensure we know remote refs when available
if git remote get-url origin >/dev/null 2>&1; then
  git fetch origin --prune || true
fi

git reset --hard "$REF"
echo "[rollback] Rolled back to: $(git rev-parse --short HEAD)"

if [ "$PUSH" = "--push" ]; then
  if git remote get-url origin >/dev/null 2>&1; then
    git push --force-with-lease origin main
    echo "[rollback] Force-pushed rollback to origin/main"
  else
    echo "[rollback] No remote 'origin' configured; skipped push"
  fi
fi

echo "[rollback] Done"
