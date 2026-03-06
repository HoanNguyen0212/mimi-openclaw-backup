# MEMORY.md - Your Long-Term Memory

This file stores important long-term memories, decisions, and learned lessons.

## Test Entry
This is a test entry to check memory storage and search functionality.
Created on 2026-03-04.

## Ops Note
Cập nhật 2026-03-06: Sếp quyết định không dùng PM2 để quản lý OpenClaw nữa do rủi ro kẹt bản cũ/bản mới sau gateway restart. Vận hành OpenClaw theo mô hình một nguồn duy nhất, tránh chạy song song nhiều gateway.

## Preference & Ops (2026-03-05)
- Sếp muốn theo dõi model hiện hành thường xuyên; nên trả lời ngắn gọn, trực tiếp khi hỏi "model đang dùng".
- Với môi trường này, ưu tiên quản lý dịch vụ bằng PM2; khi lỗi dịch vụ cần kiểm tra xung đột PATH/binary trước khi kết luận lỗi config.
