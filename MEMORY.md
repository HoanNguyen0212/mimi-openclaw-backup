# MEMORY.md - Your Long-Term Memory

This file stores important long-term memories, decisions, and learned lessons.

## Test Entry
This is a test entry to check memory storage and search functionality.
Created on 2026-03-04.

## Ops Note
PM2 thường quản lý OpenClaw trong môi trường này. Khi tinh chỉnh/nâng cấp hệ thống OpenClaw, luôn kiểm tra và tính đến PM2 (tránh xung đột tiến trình, cấu hình cũ, và trạng thái tự khởi động).

## Preference & Ops (2026-03-05)
- Sếp muốn theo dõi model hiện hành thường xuyên; nên trả lời ngắn gọn, trực tiếp khi hỏi "model đang dùng".
- Với môi trường này, ưu tiên quản lý dịch vụ bằng PM2; khi lỗi dịch vụ cần kiểm tra xung đột PATH/binary trước khi kết luận lỗi config.
