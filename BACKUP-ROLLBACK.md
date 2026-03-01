# QUICK BACKUP / ROLLBACK

## Backup ngay
bash ~/.openclaw/workspace/scripts/backup-openclaw.sh ~/.openclaw/workspace

## Rollback có chọn bản
bash ~/.openclaw/workspace/scripts/rollback-openclaw.sh --pick

## Rollback + push remote
bash ~/.openclaw/workspace/scripts/rollback-openclaw.sh --pick --push

## Kiểm tra cron backup
openclaw cron list
openclaw cron runs --id 76120add-252a-4078-94c2-37e3faedd490 --limit 10

## Máy mới / cài lại Termux
bash <(curl -fsSL https://raw.githubusercontent.com/HoanNguyen0212/mimi-openclaw-backup/main/scripts/restore-termux-fresh.sh)
