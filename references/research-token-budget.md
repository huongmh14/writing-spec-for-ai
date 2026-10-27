# Ngân sách token của bộ skill — số đo, nguồn và cách sửa

> Phiên 2026-10-27. Nhãn nguồn theo `C31`: **Đã xác minh** = mở trang, trích nguyên văn; **Đo** = chạy lệnh trong repo; **AI đề xuất** = suy luận, chưa đo trên model thật.
> Giới hạn: số token đo bằng `tiktoken` `o200k_base`. Tokenizer của Claude/Gemini không công khai nên số thật có thể lệch; dùng để so sánh tương đối, không làm số tuyệt đối.

## 1. Nguồn

| # | Khẳng định | Nhãn | Con trỏ + trích nguyên văn |
|---|---|---|---|
| S1 | Mô tả của **mọi** skill được nạp sẵn ở mỗi phiên; thân `SKILL.md` chỉ nạp khi dùng | Đã xác minh | [Claude Docs — Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices): *"At startup, only the metadata (name and description) from all Skills is pre-loaded. Claude reads SKILL.md only when the Skill becomes relevant, and reads additional files only as needed."* |
| S2 | Metadata của skill chiếm chung ngữ cảnh | Đã xác minh | S1: *"The context window is a public good. Your Skill shares the context window with everything else Claude needs, including: The system prompt Conversation history Other Skills' metadata Your actual request"* |
| S3 | Trần độ dài `SKILL.md`; tham chiếu chỉ sâu 1 cấp | Đã xác minh | S1: *"Keep the SKILL.md body under 500 lines for optimal performance."* · *"Keep references one level deep from SKILL.md."* |
| S4 | Antigravity chỉ quét skill sâu 1 cấp → skill lồng trong `writing-spec-for-ai/skills/` không bị nạp metadata | Đã xác minh (tài liệu cài cục bộ của Antigravity, `agy-customizations/docs/json_configs.md`) | *"Each entry directory is scanned **one level deep**."* |
| S4b | **Codex và OpenCode quét đệ quy mọi file tên `SKILL.md`** | Đã xác minh bằng log cục bộ & `skillctl.ps1 test` | Codex `~/.codex/sessions/…2026-10-27T06-05-14…jsonl` liệt kê `r0/writing-spec-for-ai/skills/*/SKILL.md` (tổng 1.205 token cho 11 mục). OpenCode `opencode.log` quét sâu tới `writing-spec-for-ai\skills\*\SKILL.md`. `skillctl.ps1 test` kiểm chỉ có đúng 5 file `SKILL.md` lồng của `playwright`. Đổi tên file lồng thành `sub-skill.md` khi cài gọn giúp `skillctl.ps1 test` pass và ẩn cả 10 sub-skill khỏi bộ quét đệ quy |
| S5 | Ngữ cảnh dài làm giảm độ chính xác, nên giữ tập token nhỏ nhất có tín hiệu cao | Đã xác minh | [Anthropic — Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents): *"as the number of tokens in the context window increases, the model's ability to accurately recall information from that context decreases."* · *"finding the smallest possible set of high-signal tokens that maximize the likelihood of some desired outcome."* |
| S6 | Nạp đúng lúc qua đường dẫn thay cho nạp trước | Đã xác minh | S5: *"agents built with the "just in time" approach maintain lightweight identifiers (file paths, stored queries, web links, etc.)"* |
| S7 | Tiếng Việt tốn token hơn tiếng Anh | Đo (bảng §2: tiếng Việt ≈ 3,0 ký tự/token, `LICENSE` tiếng Anh 4,78) | Nguồn thứ cấp nói "2–4,5×" không kiểm được, không dùng |

## 2. Số đo (trước khi sửa)

Lệnh tái hiện: `python -c "import tiktoken,re;e=tiktoken.get_encoding('o200k_base');print(len(e.encode(open('<file>',encoding='utf-8').read())))"`

| Phần | Ký tự | Token | Khi nào tốn |
|---|---:|---:|---|
| Mô tả 11 skill (gốc + 10 sub-skill) | 2 783 | **914** | **Mọi lượt, mọi phiên**, kể cả phiên không viết spec (S1) |
| Chỉ mô tả bộ điều phối | 312 | 97 | Như trên, sau khi sửa |
| `references/base-kit.md` toàn file | 24 591 | 8 233 | Mỗi lần chạy `spec-challenger` |
| `base-kit.md` §3 (bảng Core C01–C31) | — | 3 353 | Như trên, sau khi sửa |
| `SKILL.md` gốc / `write-spec` (lớn nhất) | 9 118 / 9 742 | 2 962 / 3 238 | Khi skill được dùng; 64 / 100 dòng, dưới trần 500 dòng (S3) và trần ratchet 65/110 dòng của `validate.ps1` |

`validate.ps1` trước đây chia cho 3,8 ký tự/token nên báo mô tả chỉ ~729 token, thấp hơn số đo 914 khoảng 20%.

## 3. Sửa gì và vì sao

| Vấn đề | Sửa | Tiết kiệm (Đo) | Căn cứ |
|---|---|---|---|
| Trình cài chép 10 sub-skill ra cấp 1 (hoặc giữ tên `SKILL.md` khi cài lồng) nên cả 11 mô tả bị nạp ở mọi phiên | Mặc định cài **gọn**: sub-skill nằm lồng tại `writing-spec-for-ai/skills/<tên>/sub-skill.md` (cùng cơ chế với `SKILL.template.md`), cập nhật link trong bản cài; đồng bộ thêm `~/.codex/agents/*.toml`. Cờ `-Standalone` / `--standalone` giữ cách cũ | 914 → 97 token mô tả (−89%); trên Codex 1.205 → 112 token/lượt | S1, S2, S4, S4b |
| Bản cài phẳng cũ: link `../../SKILL.md` của `test-docs` và `write-design-doc` trỏ ra ngoài | Chế độ standalone đổi thành `../writing-spec-for-ai/SKILL.md` | Bớt lượt tìm file | S3 |
| `spec-challenger` đọc nguyên `base-kit.md` | CONTRACT chỉ lấy bảng Core §3 | 8 233 → ~3 353 token mỗi lần review (−59%) | S5, S6 |
| Ước lượng token trong `validate.ps1` lệch | Đổi hệ số 3,8 → 3,0 | Số báo sát số đo hơn | §2 |

**Không làm (có lý do):**
- Rút gọn `SKILL.md` / `write-spec`: chúng đã dưới trần 500 dòng (S3) và đã có ratchet. Cắt thêm thì lợi nhỏ, dễ mất luật.
- Viết mô tả bằng tiếng Anh: tiết kiệm phụ thuộc tokenizer, mà cụm kích hoạt tiếng Việt cần để agent nhận ra yêu cầu. Lợi nhỏ sau khi đã còn 97 token. **AI đề xuất**: chỉ làm khi đo được trên model đang dùng.
- Đổi tên/tách file `base-kit.md`: sẽ gãy anchor `base-kit.md §3` ở `glossary.md` và `principles.md`, trong khi một dòng chỉ dẫn đã đủ.

**Đánh đổi (người dùng chốt 2026-10-27):** ở chế độ gọn không gọi thẳng được `/write-spec`, `/review-docs`… mà phải đi qua bộ điều phối. Ai cần gọi thẳng thì dùng `-Standalone`.

## 4. Kiểm chứng

- `scripts/validate.ps1` có 4 kiểm hồi quy: CONTRACT §3 của `spec-challenger`, cờ `-Standalone` trong `install.ps1`, `--standalone` trong `install.sh`, và đổi tên `sub-skill.md` khi cài gọn.
- Cài thật ở chế độ gọn rồi chạy `validate.ps1` và `~/.agents/skillctl.ps1 test` trên bản đã cài: cả hai đều `ALL CHECKS PASSED`, không còn sub-skill cấp 1, có đủ `writing-spec-for-ai/skills/*/sub-skill.md`, không link gãy.
- Chưa kiểm: hành vi trên model thật (agent có mở đúng sub-skill qua bộ điều phối không). Cách kiểm: mở phiên mới, nói "viết spec cho dự án", xem agent có mở `skills/survey-project/sub-skill.md` không.
