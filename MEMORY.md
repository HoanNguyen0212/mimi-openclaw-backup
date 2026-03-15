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
- ClawBrain backend chuẩn (via Cliproxy Multi-Key): PostgreSQL + Redis local.
- Env vận hành tập trung tại `~/.openclaw/brain.env`; script khởi chạy chuẩn tại `workspace/scripts/start-openclaw-brain.sh`.
- (Đã supersede 2026-03-08) Embeddings từng chạy qua GitHub Models endpoint (`https://models.inference.ai.azure.com`) với model `text-embedding-3-small`.
- (Đã supersede 2026-03-08) Test cũ pass với vector 1536 chiều.
- Checklist vận hành nhanh: 1 gateway PID duy nhất + `pg_isready` + `redis-cli ping` + test semantic remember/recall.

## Model Operations (2026-03-07, Cập nhật 2026-03-09)
- Cách chuyển model: dùng `session_status(model="tên-model")`.
- Quy tắc đặt tên: BẮT BUỘC dùng tiền tố `cliproxy/` cho mọi model và mọi tool (bao gồm `image`, `pdf`, `session_status`, v.v.) để đảm bảo định tuyến đúng và xác thực ổn định.
- Danh sách model hay dùng: `cliproxy/gemini-3-flash`, `cliproxy/gemini-2.5-flash`, `cliproxy/gpt-5.3-codex`.
- Sau khi chuyển, luôn gửi một xác nhận ngắn gọn kèm tên model hiện hành cho sếp.
- **Lưu ý quan trọng 2026-03-09:** Khi gặp lỗi `500 auth_unavailable` hoặc khi cần "làm mới" phiên làm việc, hãy chủ động dùng `session_status(model="cliproxy/gemini-3-flash")` (hoặc model cliproxy tương ứng) để ép nhận diện và tái xác thực hệ thống.
- **Danh sách models Cliproxy hệ thống (Ghi nhớ 2026-03-09):**
    * Gemini: `cliproxy/gemini-3-flash`, `cliproxy/gemini-2.5-flash`, `cliproxy/gemini-2.5-pro`, và các bản google/gemini tương ứng.
    * Codex: `cliproxy/gpt-5.3-codex`, `cliproxy/gpt-5.2-codex`, `cliproxy/gpt-5.1-codex-mini`.
    * Khác: `cliproxy/anthropic/claude-sonnet-4.6`, `cliproxy/anthropic/claude-opus-4.5`, `cliproxy/openai/o3`, `cliproxy/openai/gpt-5.4`, `cliproxy/deepseek/deepseek-chat-v3.1`, `cliproxy/deepseek/deepseek-r1-0528`, `cliproxy/x-ai/grok-4`, `cliproxy/qwen/qwen3-max`, `cliproxy/mistralai/mistral-large-2512`.

## Image Tool Fix (2026-03-07)
- Lỗi gốc: bước image optimizer có thể fail trên Termux (`Failed to optimize image`) trước khi gửi ảnh sang model.
- Cách sửa đúng: đổi từ fail cứng sang fallback pass-through.
  - Optimize thành công -> dùng ảnh đã tối ưu.
  - Optimize thất bại -> dùng ảnh gốc và tiếp tục luồng vision.
- Kết quả mong muốn: không bị chặn ở tiền xử lý; bot Zalo vẫn phân tích được ảnh.
- Tóm tắt: trước "optimize lỗi = fail toàn bộ", sau "optimize lỗi = tiếp tục bằng ảnh gốc".

## Style & Personality (2026-03-07, cập nhật 2026-03-15)
- Phong cách: Vui vẻ, năng động, thân thiện.
- Hình thức: Sử dụng nhiều emoji trong các câu trả lời để tạo sự sinh động và thoải mái cho sếp 🌈✨.
- Preference mới: có thể dùng tone "hỗn"/cà khịa nhẹ theo kiểu thân mật khi phù hợp ngữ cảnh, nhưng không dùng ngôn từ hạ nhục hay công kích cá nhân trực diện.
- **QUY TẮC BẮT BUỘC (2026-03-15):** Khi chat trong group Zalo "Suối Nguồn Tươi Trẻ", Mimi phải LUÔN VUÔI TƯƠI, DÙNG NHIỀU EMOJI và LUÔN NGẮN GỌN. Đây là ưu tiên hàng đầu cho bối cảnh này. 🍀✨🌈
- **Dặn dò mới (2026-03-15):** Lỗi `send failed` trên Zalo đã được khắc phục. Mimi sẽ không cần chia nhỏ tin nhắn nữa mà có thể gửi tin nhắn đầy đủ. Đồng thời, Mimi phải luôn ghi nhớ và duy trì phong cách trả lời "đầy đủ, ngắn gọn, vui tươi, nhiều emoji" trong mọi tương tác.


## Image Analysis Methodology (2026-03-07)
- Quy trình phân tích ảnh: Dùng tool `image` với model hỗ trợ vision (ưu tiên cliproxy Gemini).
- Yêu cầu phản hồi:
  1. Nhận diện nội dung chính (món ăn, địa điểm, văn bản).
  2. Trích xuất text quan trọng (địa chỉ, giá cả, thông báo hệ thống).
  3. Tóm tắt ngắn gọn ý nghĩa cho người dùng (đã gửi thành công, thông tin quán, v.v.).

## NVIDIA NIM Model Catalog (Updated 2026-03-15)
Dựa trên khảo sát hệ thống NVIDIA NIM, các model sau được tối ưu để áp dụng cho Mimi-ClawBrain:
- **Embedding (Đã cấu hình):** `nvidia/llama-3.2-nv-embedqa-1b-v2` (Dùng cho ClawBrain).
- **Reranking (Đề xuất):** `nvidia/llama-3.2-nv-rerankqa-1b-v2` (Tăng độ chính xác RAG).
- **Vision/OCR:** `nvidia/nemotron-ocr-v1` (Đọc tài liệu) và `nvidia/llama-nemotron-nano-2-vl` (Hiểu ảnh thực tế).
- **Reasoning/Chat:** `nvidia/llama-3.1-nemotron-70b-instruct` (Thông minh, suy luận mạnh).
- **High-end VLM:** `qwen/qwen3.5-vlm-400b` (Xử lý đa phương thức phức tạp).
- **Note:** Luôn dùng tiền tố `cliproxy/` khi gọi qua Gateway nếu được hỗ trợ, hoặc dùng trực tiếp `nvidia/...` với API key NIM.

## ClawBrain Embeddings Update (2026-03-08)
- Theo yêu cầu của sếp, đã thay embedding key cho ClawBrain từ GitHub PAT sang Gemini key.
- Cấu hình mới trong `~/.openclaw/brain.env`:
  - `BRAIN_EMBEDDINGS_BASE_URL=https://generativelanguage.googleapis.com`
  - `BRAIN_EMBEDDINGS_MODEL=gemini-embedding-001`
  - `BRAIN_EMBEDDINGS_API_KEY=<gemini-api-key>`
- Đã restart gateway bằng script `workspace/scripts/start-openclaw-brain.sh` (do `openclaw gateway restart` không hỗ trợ Android service mode).
- Đã test pass embedding: HTTP 200, vector 3072 chiều, xác nhận hoạt động ổn định.

## Knowledge & Skill Management (Updated 2026-03-15)
- **Cấu trúc Skill:** Mimi có hai "kho vũ khí" (thư mục skill) cần phải kiểm tra đồng thời:
    1. Thư mục hệ thống: `/data/data/com.termux/files/usr/lib/node_modules/openclaw/skills/`
    2. Thư mục người dùng (chứa các skill sếp cài thêm): `~/.openclaw/skills/`
- **Danh sách Skill cá nhân quan trọng:** Sếp đã cài các skill chuyên biệt tại thư mục người dùng bao gồm: `docx`, `xlsx`, `agent-browser`, `openzca-zalo-ops`, `vercel-sandbox`, `electron`, `dogfood`, và `find-skills`.
- **Lưu ý vận hành:** Khi sếp hỏi về skill hoặc cần sử dụng công cụ đặc biệt, Mimi PHẢI quét cả hai thư mục trên để tránh tình trạng báo "không có" trong khi sếp đã cài rồi.
