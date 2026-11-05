# AGENTS.md — writing-spec-for-ai

Repo này chứa skill `writing-spec-for-ai` (bộ điều phối) cùng các skill phụ trợ cho người mới. Dogfood chính bộ docs mình tạo ra.

## Cấu trúc

- `SKILL.md` — entry point, bộ điều phối 3 cổng (chỉ 64 dòng, không thêm logic vào đây)
- `skills/` — sub-skills của bộ điều phối + skill người mới (`auto-guide`, `starter-guide`, `cheat-sheet`, `writing-spec-simple`, `idea-to-spec`)
- `agents/` — subagent definitions (`spec-surveyor`, `spec-challenger`, `doc-tester`)
- `references/` — core laws `C01–C31`, principles, glossary, examples
- `templates/` — mẫu `AGENTS.md`, `CONSTRAINTS.md`, spec, decisions, progress
- `profiles.md` — cấu hình theo quy mô dự án (S/M/L)
- `docs/` — research, phân tích, evaluation logs
- `scripts/` — health check, evaluation checklist
- `packs/` — skill packs mở rộng (API, DB, auth, observability...)

## Skill loading rules (chống tràn context)

- Mỗi lượt chỉ mở **1 file `SKILL.md`** của bước đang làm; cấm đọc trước bước sau.
- Frontmatter YAML (`description`, `trigger_phrases`, `do_not_use`) là tầng luôn nạp — giữ < 100 token.
- `SKILL.md` giữ < 500 dòng; nội dung dài → `references/`; mẫu tái dùng → `templates/`; tác vụ có đáp án đúng → `scripts/`.
- Skills hot (~39) tự nạp; skills cold tra bằng `skillctl search <keyword>`, bật bằng `skillctl add`, gỡ bằng `skillctl remove`. Không đưa skill vào hot tier chỉ để dùng một lần.
- Routing: `auto-guide` là bộ định tuyến duy nhất; `starter-guide`/`cheat-sheet` chỉ là tài liệu tham khảo, không tự trigger cho tác vụ code thường.

## Verify

```bash
bash scripts/skill-health-check.sh   # validate license, When-NOT-to-use, cấu trúc
```

## Quy ước

- Một sự thật một chỗ: file khác trỏ bằng link/ID, không copy nội dung.
- Không bịa requirement; mơ hồ → `[CẦN LÀM RÕ]`.
- File `templates/` không chứa mã luật `Cxx`; file gốc dùng ID luật.
