#!/usr/bin/env bash
set -euo pipefail

# Rollback workspace repo with optional interactive commit picker.
# Usage:
#   rollback-openclaw.sh [ref] [--pick] [--push]

REPO_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
REF=""
PUSH="false"
PICK="false"

for arg in "$@"; do
  case "$arg" in
    --push) PUSH="true" ;;
    --pick) PICK="true" ;;
    -h|--help)
      echo "Usage: $0 [ref] [--pick] [--push]"
      exit 0
      ;;
    *)
      if [ -z "$REF" ]; then REF="$arg"; else echo "[rollback] Unexpected argument: $arg" >&2; exit 1; fi
      ;;
  esac
done

cd "$REPO_DIR"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "[rollback] Not a git repository: $REPO_DIR" >&2; exit 1; }
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "[rollback] Working tree has uncommitted changes. Commit/stash first." >&2
  exit 1
fi

if [ "$PICK" = "true" ] || [ -z "$REF" ]; then
  echo "[rollback] Chọn bản muốn quay lại (10 bản gần nhất):"
  git log --oneline -n 10 | nl -w2 -s'. '
  read -r -p "Nhập số thứ tự (1-10): " idx
  [[ "$idx" =~ ^[0-9]+$ ]] || { echo "[rollback] Số không hợp lệ" >&2; exit 1; }
  REF="$(git log --oneline -n 10 | sed -n "${idx}p" | awk '{print $1}')"
  [ -n "$REF" ] || { echo "[rollback] Không tìm thấy commit cho lựa chọn: $idx" >&2; exit 1; }
fi

stamp="$(date +'%Y%m%d-%H%M%S')"
safety_tag="pre-rollback-${stamp}"
git tag "$safety_tag"
echo "[rollback] Safety tag created: $safety_tag"

git fetch origin --prune >/dev/null 2>&1 || true

target_line="$(git log --oneline -n 1 "$REF" 2>/dev/null || true)"
[ -n "$target_line" ] || { echo "[rollback] Ref không hợp lệ: $REF" >&2; exit 1; }

echo "[rollback] Sẽ rollback về: $target_line"
read -r -p "Xác nhận rollback? (yes/no): " confirm
[ "$confirm" = "yes" ] || { echo "[rollback] Hủy"; exit 0; }

git reset --hard "$REF"
echo "[rollback] Rolled back to: $(git rev-parse --short HEAD)"

if [ "$PUSH" = "true" ]; then
  git push --force-with-lease origin main
  echo "[rollback] Force-pushed rollback to origin/main"
fi

echo "[rollback] Done"
