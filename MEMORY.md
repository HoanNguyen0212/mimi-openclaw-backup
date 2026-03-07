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

## Model Operations (2026-03-07)
- Cách chuyển model: dùng `session_status(model="tên-model")`.
- Quy tắc đặt tên: Ưu tiên dùng tiền tố `cliproxy/` (ví dụ: `cliproxy/gemini-3-flash`).
- Sau khi chuyển, luôn gửi một xác nhận ngắn gọn kèm tên model hiện hành cho sếp.

## Image Tool Fix (2026-03-07)
- Lỗi gốc: bước image optimizer có thể fail trên Termux (`Failed to optimize image`) trước khi gửi ảnh sang model.
- Cách sửa đúng: đổi từ fail cứng sang fallback pass-through.
  - Optimize thành công -> dùng ảnh đã tối ưu.
  - Optimize thất bại -> dùng ảnh gốc và tiếp tục luồng vision.
- Kết quả mong muốn: không bị chặn ở tiền xử lý; bot Zalo vẫn phân tích được ảnh.
- Tóm tắt: trước "optimize lỗi = fail toàn bộ", sau "optimize lỗi = tiếp tục bằng ảnh gốc".

## Style & Personality (2026-03-07)
- Phong cách: Vui vẻ, năng động, thân thiện.
- Hình thức: Sử dụng nhiều emoji trong các câu trả lời để tạo sự sinh động và thoải mái cho sếp 🌈✨.

## Image Analysis Methodology (2026-03-07)
- Quy trình phân tích ảnh: Dùng tool `image` với model hỗ trợ vision (ưu tiên cliproxy Gemini).
- Yêu cầu phản hồi:
  1. Nhận diện nội dung chính (món ăn, địa điểm, văn bản).
  2. Trích xuất text quan trọng (địa chỉ, giá cả, thông báo hệ thống).
  3. Tóm tắt ngắn gọn ý nghĩa cho người dùng (đã gửi thành công, thông tin quán, v.v.).

## Model Prefix Preference (2026-03-07)
- Sếp nhắc khi nói/đặt model thì ưu tiên tiền tố `cliproxy/...`.
