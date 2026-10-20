---
name: writing-spec-for-ai
description: Kích hoạt khi bắt đầu dự án mới, khi repo chưa có hoặc có tài liệu AI rời rạc, hoặc khi người dùng nói "viết spec", "viết AGENTS.md", "thiết kế docs cho AI", "chuẩn hoá tài liệu cho agent". Điều phối quy trình thiết kế bộ tài liệu điều khiển AI agent (AGENTS.md, CONSTRAINTS.md, glossary, decisions, spec REQ/NFR/AC, design, plan, verify skill) qua 3 cổng duyệt trước khi viết code.
---

# Writing Spec For AI

Mục tiêu: bộ tài liệu giúp mọi AI agent **làm đúng luật, tự chứng minh việc đã xong, biết dừng khi mơ hồ** — và ngắn nhất có thể.

Skill này là **bộ điều phối**. Mỗi bước có một sub-skill chi tiết trong [skills/](skills/) và 3 subagent chuyên biệt trong [agents/](agents/) — **bắt buộc mở đọc đúng file sub-skill trước khi thực hiện bước đó**. Nền tảng nguyên tắc: [references/principles.md](references/principles.md). Ví dụ chuẩn từ dự án thật: [references/examples.md](references/examples.md). Mẫu file: [templates/](templates/). Luật kế thừa cho mọi dự án (Core `C01–C27`, 8 Domain Packs `PK-*`, Profile `S/M/L`, luật ghi đè): [references/base-kit.md](references/base-kit.md) — dự án ghi phiên bản base đang dùng ở đầu `AGENTS.md`.

## Luật cứng

1. **Ba cổng duyệt:** đề xuất thiết kế (Cổng 1) → tự kiểm & phản biện docs (Cổng 2) → thử nghiệm docs bằng task mẫu (Cổng 3) → mới code. Không bỏ cổng nào.
2. **Không bịa yêu cầu.** Không suy ra được từ repo hoặc lời người dùng → `[CẦN LÀM RÕ: …]` + câu hỏi mở.
3. **Một sự thật, một chỗ.** Nơi khác link/ID bằng **context pointer** đặt điều kiện kích hoạt ở đầu câu (`C24`).
4. **Mức 0 luôn làm; mức 1–2 và Pack chỉ khi có tín hiệu**, ghi rõ tín hiệu.
5. **Ngắn & chống hạ chuẩn:** `AGENTS.md` ≤ ~150 dòng; không tự thêm suppression/hạ ngưỡng để qua bài kiểm (`C23`).
6. Ngôn ngữ tài liệu theo người dùng; ID, lệnh, tên file giữ nguyên.

## Chống ngụy biện (Red Flags — Dừng ngay nếu đang nghĩ)

| Ngụy biện dưới áp lực thời gian / uy quyền | Hành động bắt buộc |
|---|---|
| *"Dự án nhỏ / đang gấp, viết luôn `AGENTS.md` khỏi cần đề xuất Cổng 1"* | **Dừng.** Dự án nhỏ dùng Profile `S` (đề xuất gọn ~15 dòng), vẫn bắt buộc chốt Cổng 1 trước khi tạo file trong repo. |
| *"Chỉ thiếu vài chi tiết nhỏ, tự đoán luôn cho nhanh"* | **Dừng.** Đánh dấu `[CẦN LÀM RÕ]` hoặc hỏi theo `HYPOTHESIS + GUESS` ở Bước 4; tuyệt đối không bịa REQ/AC. |
| *"Tự đọc lại thấy ổn rồi, bỏ qua `spec-challenger` (Cổng 2) và `doc-tester` (Cổng 3)"* | **Dừng.** Người viết luôn mắc điểm mù xác nhận (`C26`); phải chạy kiểm tra context sạch và được người dùng duyệt mới sang bước tiếp. |
| *"Mô tả trong bảng/YAML đã tóm tắt rồi, khỏi mở đọc file sub-skill"* | **Dừng.** YAML `description` chỉ là con trỏ kích hoạt; bắt buộc mở đọc `skills/<bước>/SKILL.md` trước khi làm. |

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
