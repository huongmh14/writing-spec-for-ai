---
name: writing-spec-for-ai
description: Thiết kế bộ tài liệu hướng dẫn AI agent cho một dự án — AGENTS.md, adapter từng công cụ, glossary, decisions/ADR, spec REQ/NFR/AC, design, change proposal, plan, progress/handoff, hook và skill dự án. Kích hoạt khi bắt đầu dự án mới, khi repo chưa có hoặc có tài liệu cho AI rời rạc, khi người dùng nói "viết spec", "viết AGENTS.md", "thiết kế docs cho AI", "chuẩn hoá tài liệu cho agent". Luôn trình đề xuất để người dùng review trước, không viết code trước khi docs được duyệt.
---

# Writing Spec For AI

Mục tiêu: bộ tài liệu giúp mọi AI agent **làm đúng luật, tự chứng minh việc đã xong, biết dừng khi mơ hồ** — và ngắn nhất có thể.

Skill này là **bộ điều phối**. Mỗi bước có một sub-skill chi tiết trong [skills/](skills/) — mở đúng sub-skill khi làm bước đó. Nền tảng nguyên tắc: [references/principles.md](references/principles.md) (§2 bộ kỹ năng mức 0/1/2, §3 quy tắc spec, §4 phong cách, §5 ma trận công cụ). Ví dụ chuẩn từ dự án thật: [references/examples.md](references/examples.md). Mẫu file: [templates/](templates/). Luật kế thừa cho mọi dự án (Core C-xx, Pack, Profile S/M/L, luật ghi đè): [references/base-kit.md](references/base-kit.md) — dự án ghi phiên bản base đang dùng ở đầu `AGENTS.md`.

## Luật cứng

1. **Ba cổng duyệt:** đề xuất thiết kế → docs đã viết → (sau thử nghiệm) mới code. Không bỏ cổng nào.
2. **Không bịa yêu cầu.** Không suy ra được từ repo hoặc lời người dùng → `[CẦN LÀM RÕ: …]` + câu hỏi mở.
3. **Một sự thật, một chỗ.** Nơi khác link/ID.
4. **Mức 0 luôn làm; mức 1–2 chỉ khi có tín hiệu**, ghi rõ tín hiệu.
5. **Ngắn:** `AGENTS.md` ≤ ~150 dòng; mỗi dòng phải qua câu hỏi "bỏ đi agent có làm sai không?".
6. Ngôn ngữ tài liệu theo người dùng; ID, lệnh, tên file giữ nguyên.

## Quy trình — bước nào mở sub-skill đó

| Bước | Việc | Sub-skill | Cổng |
|---|---|---|---|
| 1–2 | Khảo sát dự án, thu bằng chứng, xác định mức 0/1/2 | [skills/survey-project](skills/survey-project/SKILL.md) | |
| 3 | Đề xuất thiết kế docs (chưa tạo file repo) | [skills/propose-doc-design](skills/propose-doc-design/SKILL.md) | **Cổng 1 — chờ duyệt** |
| 4 | Làm rõ từng câu hỏi; đáp án → decisions (D-xx) hoặc spec | (nội quy trong propose-doc-design §3) | |
| 5a | Viết AGENTS.md, glossary, decisions, adapters theo `templates/` | templates + principles §4.2 | |
| 5b | Viết từng spec REQ/NFR/AC | [skills/write-spec](skills/write-spec/SKILL.md) | |
| 5c | Viết design doc khi có tín hiệu | [skills/write-design-doc](skills/write-design-doc/SKILL.md) | |
| 6 | Tự kiểm checklist, lập báo cáo | [skills/review-docs](skills/review-docs/SKILL.md) | **Cổng 2 — chờ duyệt** |
| 7 | Thử docs bằng 2–3 task mẫu (phiên mới) | [skills/test-docs](skills/test-docs/SKILL.md) | **Cổng 3 — chờ duyệt mới code** |
| 8 | Code theo quy trình bộ docs định nghĩa | (theo AGENTS.md của dự án) | |

Luật xuyên các bước:

- Bước 4: hỏi **từng câu một**, kèm phương án đề xuất và hệ quả; tối đa ~5 câu một lượt, câu ảnh hưởng lớn nhất trước.
- Bước 5: chép mẫu từ `templates/`, điền giá trị thật, xoá phần không áp dụng; không để placeholder trong file giao; lệnh trong AGENTS.md phải chạy được (chạy thử nếu an toàn). Spec mới `Draft`; brownfield `As-built` kèm bằng chứng; chỉ người dùng chuyển `Ready`.
- Bước 8: phát hiện docs sai/thiếu khi code → dừng, đề xuất sửa docs trước; spec đã `Done` thì qua [skills/change-spec](skills/change-spec/SKILL.md).

## Sau khi code chạy (bảo trì)

- Luật vi phạm ≥ 2 lần → lint/test/hook, thông báo lỗi kèm ID luật + cách sửa; rút văn xuôi.
- Quy trình lặp ≥ 2 lần → skill dự án ([templates/project-skill](templates/project-skill/SKILL.md)).
- Lỗi khó đã gặp → gotchas trong guide/skill; chưa sửa thì có issue.
- File đọc mỗi phiên > ~5 KB → lưu trữ phần cũ (progress cũ → `progress-archive/`).
- Làm xong P-xx → chuyển D-xx hoặc xoá. Spec đủ AC → `Done` (trong PR cuối của spec).
