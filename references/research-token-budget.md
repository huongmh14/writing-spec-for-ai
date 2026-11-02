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

## 5. Phiên 2026-11-02 — cổng chỉ dẫn mơ hồ và nén ngữ cảnh

Vấn đề người dùng nêu: prompt chưa rõ thì AI vẫn đoán một cách hiểu rồi chạy cả vòng đọc → sửa → test → phản biện; phiên dài thì bộ nén của công cụ làm rơi trạng thái đợt đang làm.

| # | Khẳng định | Nhãn | Con trỏ + trích nguyên văn |
|---|---|---|---|
| S8 | Claude Code đọc lại `CLAUDE.md` gốc sau `/compact` | Đã xác minh | [Claude Code — Memory](https://code.claude.com/docs/en/memory): *"Project-root CLAUDE.md survives compaction: after `/compact`, Claude re-reads it from disk and re-injects it into the session."* |
| S9 | Chỉ dẫn bộ nén giữ gì bằng một mục trong `CLAUDE.md` | Đã xác minh | [Claude Code — Costs](https://code.claude.com/docs/en/costs): *"# Compact instructions — When you are using compact, please focus on test output and code changes"* |
| S10 | Hook `SessionStart` matcher `compact` bơm lại ngữ cảnh sau mỗi lần nén; stdout vào ngữ cảnh | Đã xác minh | [Claude Code — Hooks guide](https://code.claude.com/docs/en/hooks-guide): *"Use a `SessionStart` hook with a `compact` matcher to re-inject critical context after every compaction."* · *"Claude Code adds plain text your command writes to stdout to Claude's context."* |
| S11 | `PreCompact` chỉ chặn được việc nén, không bơm ngữ cảnh | Đã xác minh | [Claude Code — Hooks](https://code.claude.com/docs/en/hooks): *"Exit with code 2 to block compaction"* · *"Claude Code discards a PreCompact hook's `systemMessage` and `continue` fields."* |
| S12 | Codex: `compact_prompt` không được dùng khi nhà cung cấp nén từ xa (V2) | Đã xác minh (mã nguồn qua Context7, 2026-11-02) | [codex-rs/core/src/tasks/compact.rs](https://github.com/openai/codex/blob/main/codex-rs/core/src/tasks/compact.rs): nhánh `RemoteCompactionSupport::V2` gọi `run_remote_compact_task` mà không đọc `compact_prompt`; chỉ nhánh `Unsupported` đọc |
| S13 | Hook của Antigravity không có sự kiện nén | Đã xác minh (tài liệu cài cục bộ `agy-customizations/docs/hooks.md`) | Danh sách sự kiện chỉ gồm `SessionStart`, `PreToolUse`, `PostToolUse`, `PreInvocation`, `PostInvocation`, `Stop` |
| S14 | Cursor có sự kiện hook quanh việc nén | Chưa biết | Chưa mở tài liệu chính thức; không đưa vào mẫu. Cách kiểm: đọc docs hooks của Cursor bản hiện hành |

**Sửa gì (AI đề xuất, dựa trên nguồn trên và [research-controlled-execution.md](research-controlled-execution.md) §2–3A):**

| Vấn đề | Sửa | Căn cứ |
|---|---|---|
| Prompt mơ hồ → chạy cả vòng theo cách hiểu đoán | `templates/AGENTS.md` bước 1: chỉ dẫn rõ → làm luôn, không hỏi lại; mơ hồ → tra cứu có mục tiêu, vẫn mơ hồ thì **bản chốt nhanh ≤ 5 dòng** rồi dừng. Chỉ tốn thêm một lượt ngắn khi thật sự mơ hồ | GitHub Docs (§2 của nghiên cứu kia); §3A: lệnh chưa xác định được phần việc thì trình phần việc để người dùng chọn |
| Bộ nén làm rơi RUN-ID, file đã sửa, lỗi chưa đóng | Bàn giao trong `progress.md` thêm *File đã sửa · Lệnh kiểm + lỗi chưa đóng · Hướng đã loại*; ghi đè theo mốc sự kiện thay cho đếm token | S8–S10 |
| Tóm tắt sau nén mang "việc kế tiếp" như thể đã được giao hoặc lệch trạng thái do nén giữa đợt | Sau nén đọc lại block đợt: quyền/phạm vi theo `progress.md` (tóm tắt không cấp quyền); trạng thái code/test lệch thì kiểm chứng lại bằng workspace + lệnh kiểm rồi cập nhật `progress.md` | Quyền thực thi theo đợt |
| Claude Code | Adapter `CLAUDE.md` thêm `# Compact instructions`; `claude-settings.json` thêm hook `SessionStart`/`compact` neo `${CLAUDE_PROJECT_DIR}` in block đợt (phần trước `## Lịch sử`, bỏ lịch sử để đỡ token, không phụ thuộc thư mục hiện hành) | S8, S9, S10 |

**Không làm (có lý do):**
- Hook đếm token hoặc chèn cảnh báo mỗi lượt (kể cả qua `PreInvocation` của Antigravity): đó là lý do luật quản lý phiên bị bỏ ngày 2026-10-26 ([CHANGELOG](../CHANGELOG.md)) — ước lượng token tiếng Việt sai và quản lý phiên thuộc công cụ.
- Hook `PreCompact`: không bơm được ngữ cảnh (S11); chặn nén tự động sát trần làm request lỗi.
- Cấu hình `compact_prompt` / `model_auto_compact_token_limit` của Codex: nằm ở `~/.codex/config.toml` của máy người dùng, và `compact_prompt` không có tác dụng khi nén từ xa (S12). Luật "sau khi nén đọc lại `progress.md`" trong `AGENTS.md` áp cho mọi công cụ.
- Hook cho Antigravity / Cursor: Antigravity không có sự kiện nén (S13); Cursor chưa xác minh (S14).

**Kiểm chứng:** `scripts/validate.ps1` thêm 4 marker (bản chốt nhanh, đọc lại sau nén, `# Compact instructions`, matcher `compact`) và eval-16, eval-17. Lệnh hook đã chạy thử bằng Git Bash: in đến dòng `## Lịch sử`, thiếu file thì im lặng và thoát 0. Chưa kiểm: hành vi trên model thật; cách kiểm: chạy eval-16/17, hoặc `/compact` trong phiên Claude Code rồi hỏi "đợt hiện tại là gì".
