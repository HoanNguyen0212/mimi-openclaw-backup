#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Rollback workspace repo with optional interactive commit picker.
# Usage:
#   rollback-openclaw.sh [ref] [--pick] [--index N] [--yes] [--push]

REPO_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
REF=""
PUSH="false"
PICK="false"
INDEX=""
ASSUME_YES="false"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --push) PUSH="true" ; shift ;;
    --pick) PICK="true" ; shift ;;
    --yes) ASSUME_YES="true" ; shift ;;
    --index)
      INDEX="${2:-}"
      [ -n "$INDEX" ] || { echo "[rollback] --index requires a number" >&2; exit 1; }
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [ref] [--pick] [--index N] [--yes] [--push]"
      echo "  --pick      Show last 10 commits and choose one"
      echo "  --index N   Non-interactive selection from the shown list (1..10)"
      echo "  --yes       Skip yes/no confirmation"
      exit 0
      ;;
    *)
      if [ -z "$REF" ]; then REF="$1"; shift; else echo "[rollback] Unexpected argument: $1" >&2; exit 1; fi
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
  mapfile -t commits < <(git --no-pager log --oneline -n 10)
  [ "${#commits[@]}" -gt 0 ] || { echo "[rollback] Không có commit nào để chọn" >&2; exit 1; }

  i=1
  for line in "${commits[@]}"; do
    printf "%2d. %s\n" "$i" "$line"
    i=$((i+1))
  done

  if [ -n "$INDEX" ]; then
    idx="$INDEX"
    echo "[rollback] Dùng --index: $idx"
  else
    if [ ! -t 0 ]; then
      echo "[rollback] Phiên không tương tác (non-interactive). Dùng --index N hoặc chỉ định ref trực tiếp." >&2
      exit 1
    fi
    read -r -p "Nhập số thứ tự (1-10): " idx
  fi

  [[ "$idx" =~ ^[0-9]+$ ]] || { echo "[rollback] Số không hợp lệ" >&2; exit 1; }
  [ "$idx" -ge 1 ] && [ "$idx" -le "${#commits[@]}" ] || { echo "[rollback] Số ngoài phạm vi" >&2; exit 1; }

  REF="$(echo "${commits[$((idx-1))]}" | awk '{print $1}')"
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
if [ "$ASSUME_YES" = "true" ]; then
  confirm="yes"
  echo "[rollback] --yes: tự động xác nhận"
else
  if [ ! -t 0 ]; then
    echo "[rollback] Phiên không tương tác, thiếu xác nhận. Dùng --yes để tiếp tục." >&2
    exit 1
  fi
  read -r -p "Xác nhận rollback? (yes/no): " confirm
fi
[ "$confirm" = "yes" ] || { echo "[rollback] Hủy"; exit 0; }

git reset --hard "$REF"
echo "[rollback] Rolled back to: $(git rev-parse --short HEAD)"

if [ "$PUSH" = "true" ]; then
  branch="$(git rev-parse --abbrev-ref HEAD)"
  git push --force-with-lease origin "$branch"
  echo "[rollback] Force-pushed rollback to origin/$branch"
fi

echo "[rollback] Done"
