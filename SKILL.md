---
name: writing-spec-for-ai
description: Thiết kế bộ tài liệu hướng dẫn AI agent cho một dự án — AGENTS.md, CONSTRAINTS.md, adapter từng công cụ, glossary, decisions/ADR, spec REQ/NFR/AC, design, change proposal, plan (Tracer Bullets), progress/handoff, hook và skill kiểm chứng dự án. Kích hoạt khi bắt đầu dự án mới, khi repo chưa có hoặc có tài liệu cho AI rời rạc, khi người dùng nói "viết spec", "viết AGENTS.md", "thiết kế docs cho AI", "chuẩn hoá tài liệu cho agent". Luôn trình đề xuất để người dùng review trước, không viết code trước khi docs được duyệt.
---

# Writing Spec For AI

Mục tiêu: bộ tài liệu giúp mọi AI agent **làm đúng luật, tự chứng minh việc đã xong, biết dừng khi mơ hồ** — và ngắn nhất có thể.

Skill này là **bộ điều phối**. Mỗi bước có một sub-skill chi tiết trong [skills/](skills/) và 3 subagent chuyên biệt trong [agents/](agents/) — mở đúng sub-skill khi làm bước đó. Nền tảng nguyên tắc: [references/principles.md](references/principles.md). Ví dụ chuẩn từ dự án thật: [references/examples.md](references/examples.md). Mẫu file: [templates/](templates/). Luật kế thừa cho mọi dự án (Core `C01–C27`, 8 Domain Packs `PK-*`, Profile `S/M/L`, luật ghi đè): [references/base-kit.md](references/base-kit.md) — dự án ghi phiên bản base đang dùng ở đầu `AGENTS.md`.

## Luật cứng

1. **Ba cổng duyệt:** đề xuất thiết kế → docs đã viết → (sau thử nghiệm) mới code. Không bỏ cổng nào.
2. **Không bịa yêu cầu.** Không suy ra được từ repo hoặc lời người dùng → `[CẦN LÀM RÕ: …]` + câu hỏi mở.
3. **Một sự thật, một chỗ.** Nơi khác link/ID bằng **context pointer** đặt điều kiện kích hoạt ở đầu câu (`C24`).
4. **Mức 0 luôn làm; mức 1–2 và Pack chỉ khi có tín hiệu**, ghi rõ tín hiệu.
5. **Ngắn & chống hạ chuẩn:** `AGENTS.md` ≤ ~150 dòng; không tự thêm suppression/hạ ngưỡng để qua bài kiểm (`C23`).
6. Ngôn ngữ tài liệu theo người dùng; ID, lệnh, tên file giữ nguyên.

## Quy trình — bước nào mở sub-skill / subagent đó

| Bước | Việc | Sub-skill / Subagent | Cổng |
|---|---|---|---|
| 1–2 | Khảo sát dự án, thu bằng chứng, xác định mức 0/1/2, Profile & Pack | [skills/survey-project](skills/survey-project/SKILL.md) · subagent [`spec-surveyor`](agents/spec-surveyor.md) | |
| 3 | Đề xuất thiết kế docs + Capability Map (chưa tạo file repo) | [skills/propose-doc-design](skills/propose-doc-design/SKILL.md) | **Cổng 1 — chờ duyệt** |
| 4 | Làm rõ theo Frontier + `HYPOTHESIS/GUESS`; đáp án → `D-xx` hoặc spec | (nội quy trong `propose-doc-design` §3) | |
| 5a | Viết `AGENTS.md`, `CONSTRAINTS.md` (M/L), `glossary`, `decisions`, adapters | [templates/](templates/) + `principles.md` §4.2 | |
| 5b | Viết từng spec REQ/NFR/AC (kế thừa REQ từ `packs/PK-*.md`) | [skills/write-spec](skills/write-spec/SKILL.md) | |
| 5c | Viết design doc (Deep Modules, Seams, Design It Twice) khi có tín hiệu | [skills/write-design-doc](skills/write-design-doc/SKILL.md) | |
| 6 | Phản biện đối kháng & chấm checklist | [skills/review-docs](skills/review-docs/SKILL.md) · subagent [`spec-challenger`](agents/spec-challenger.md) | **Cổng 2 — chờ duyệt** |
| 7 | Thử docs bằng 2–3 task mẫu trong phiên sạch | [skills/test-docs](skills/test-docs/SKILL.md) · subagent [`doc-tester`](agents/doc-tester.md) | **Cổng 3 — chờ duyệt mới code** |
| 7.5 | *(Tuỳ chọn)* Chẻ Spec thành đồ thị Tracer-Bullet tasks & tạo skill verify | [skills/plan-tasks](skills/plan-tasks/SKILL.md) · [skills/generate-verify-harness](skills/generate-verify-harness/SKILL.md) | |
| 8 | Code theo quy trình bộ docs định nghĩa; quản lý thay đổi spec | [skills/change-spec](skills/change-spec/SKILL.md) | |

Luật xuyên các bước:

- Bước 4: nêu `HYPOTHESIS` + `CONFIDENCE %`, hỏi các câu trên **Frontier**, mỗi câu kèm phương án đề xuất (`GUESS`) và hệ quả; tối đa ~5 câu một lượt, câu ảnh hưởng lớn nhất trước.
- Bước 5: chép mẫu từ `templates/`, điền giá trị thật, xoá phần không áp dụng; không để placeholder trong file giao; lệnh trong `AGENTS.md` / `CONSTRAINTS.md` phải chạy được. Spec mới `Draft`; brownfield `As-built` kèm bằng chứng; chỉ người dùng chuyển `Ready`.
- Bước 8: phát hiện docs sai/thiếu khi code → dừng, đề xuất sửa docs trước; spec đã `Done` thì qua [skills/change-spec](skills/change-spec/SKILL.md).

## Sau khi code chạy (bảo trì)

- Luật vi phạm ≥ 2 lần → đưa vào `CONSTRAINTS.md` / lint / test / hook, thông báo lỗi kèm ID luật + cách sửa; rút văn xuôi.
- Quy trình lặp ≥ 2 lần hoặc cần kiểm chứng runtime tự động → dùng [skills/generate-verify-harness](skills/generate-verify-harness/SKILL.md) hoặc [templates/project-skill](templates/project-skill/SKILL.md).
- Lỗi khó đã gặp → gotchas kèm ngày kiểm lần cuối (`C18`); chưa sửa thì có issue.
- File đọc mỗi phiên > ~5 KB → lưu trữ phần cũ (progress cũ → `progress-archive/`).
- Làm xong P-xx → chuyển D-xx hoặc xoá. Spec đủ AC → `Done` (trong PR cuối của spec).
