# Backup & Rollback (Nhanh gọn)

## 1) Backup ngay (manual)
```bash
bash ~/.openclaw/workspace/scripts/backup-openclaw.sh ~/.openclaw/workspace
```

## 2) Kiểm tra backup tự động
```bash
openclaw cron list
openclaw cron runs --id 76120add-252a-4078-94c2-37e3faedd490 --limit 5
```

## 3) Rollback nhanh khi lỗi
### A. Rollback local (không đẩy remote)
```bash
bash ~/.openclaw/workspace/scripts/rollback-openclaw.sh HEAD~1
```

### B. Rollback + cập nhật luôn GitHub
```bash
bash ~/.openclaw/workspace/scripts/rollback-openclaw.sh <commit_or_tag> --push
```

> Script tự tạo `pre-rollback-YYYYmmdd-HHMMSS` tag trước khi rollback để có đường lui.

## 4) Restore khi cài lại Termux như mới
### One-liner
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/HoanNguyen0212/mimi-openclaw-backup/main/scripts/restore-termux-fresh.sh)
```

### Hoặc cách local
```bash
# Sau khi clone repo backup
bash ~/.openclaw/workspace/scripts/restore-termux-fresh.sh
```

## 5) Lưu ý quan trọng
Backup repo này **chỉ lưu workspace**:
- AGENTS.md / SOUL.md / USER.md / IDENTITY.md / HEARTBEAT.md / MEMORY.md / memory/

Không lưu:
- `~/.openclaw` (credentials, auth tokens, session history runtime)

Nếu cần "full restore 100%", phải backup thêm `~/.openclaw` riêng (khuyến nghị mã hóa).
