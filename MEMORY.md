# MEMORY.md - Your Long-Term Memory

This file stores important long-term memories, decisions, and learned lessons.

## Test Entry
This is a test entry to check memory storage and search functionality.
Created on 2026-03-04.

## Ops Note
Cập nhật 2026-03-06: Sếp quyết định không dùng PM2 để quản lý OpenClaw nữa do rủi ro kẹt bản cũ/bản mới sau gateway restart. Vận hành OpenClaw theo mô hình một nguồn duy nhất, tránh chạy song song nhiều gateway.

## Preference & Ops (2026-03-05)
- Sếp muốn theo dõi model hiện hành thường xuyên; nên trả lời ngắn gọn, trực tiếp khi hỏi "model đang dùng".
- Ghi chú cũ (đã supersede): từng ưu tiên quản lý dịch vụ bằng PM2; hiện không áp dụng cho OpenClaw gateway.

## ClawBrain Ops Baseline (2026-03-06)
- OpenClaw gateway không chạy qua PM2; vận hành theo một tiến trình duy nhất để tránh kẹt bản cũ/mới sau restart.
- ClawBrain backend chuẩn: PostgreSQL + Redis local.
- Env vận hành tập trung tại `~/.openclaw/brain.env`; script khởi chạy chuẩn tại `workspace/scripts/start-openclaw-brain.sh`.
- Embeddings hiện chuyển sang GitHub Models endpoint (`https://models.inference.ai.azure.com`) với model `text-embedding-3-small`.
- Đã test pass: `/embeddings` HTTP 200, vector 1536 chiều; remember/recall hoạt động ổn.
- Checklist vận hành nhanh: 1 gateway PID duy nhất + `pg_isready` + `redis-cli ping` + test semantic remember/recall.
