---
name: writing-spec-for-ai
description: Kích hoạt khi bắt đầu dự án mới, khi repo chưa có hoặc có tài liệu AI rời rạc, hoặc khi người dùng nói "viết spec", "viết AGENTS.md", "thiết kế docs cho AI", "chuẩn hoá tài liệu cho agent". Điều phối quy trình thiết kế bộ tài liệu điều khiển AI agent (AGENTS.md, CONSTRAINTS.md, glossary, decisions, spec REQ/NFR/AC, design, plan, verify skill) qua 3 cổng duyệt trước khi viết code.
---

# Writing Spec For AI

Mục tiêu: bộ tài liệu giúp mọi AI agent **làm đúng luật, tự chứng minh việc đã xong, biết dừng khi mơ hồ** — và ngắn nhất có thể.

Skill này là **bộ điều phối**. Mỗi bước mở đúng sub-skill trong [skills/](skills/) trước khi làm. Nguyên tắc: [references/principles.md](references/principles.md). Ví dụ: [references/examples.md](references/examples.md). Mẫu: [templates/](templates/). Luật Core `C01–C32`, Pack và Profile: [references/base-kit.md](references/base-kit.md). Nghiên cứu cho bản sửa: [references/research-controlled-execution.md](references/research-controlled-execution.md).

## Luật cứng

1. **Mặc định ba cổng:** đề xuất (Cổng 1) → phản biện docs (Cổng 2) → thử docs (Cổng 3) → code. Chỉ dẫn rõ của người dùng có thể điều chỉnh quy trình/phạm vi; không biến giả định thành bằng chứng và không hỏi lại quyền đã cấp.
2. **Không bịa yêu cầu.** Không suy ra được từ repo hoặc lời người dùng → `[CẦN LÀM RÕ: …]` + câu hỏi mở.
3. **Một sự thật, một chỗ.** Nơi khác link/ID bằng **context pointer** đặt điều kiện kích hoạt ở đầu câu (`C24`).
4. **Mức 0 luôn làm; mức 1–2 và Pack chỉ khi có tín hiệu**, ghi rõ tín hiệu.
5. **Ngắn & chống hạ chuẩn:** `AGENTS.md` ≤ ~150 dòng; không tự thêm suppression/hạ ngưỡng để qua bài kiểm (`C23`).
6. Ngôn ngữ tài liệu theo người dùng; ID, lệnh, tên file giữ nguyên.
7. **Quyền theo đợt cho cả Docs & Code (`C30`):** `Ready` và duyệt Cổng 1 không cấp quyền viết tràn lan. **Khi viết docs (Bước 5):** mỗi lượt chỉ viết **1 file lớn hoặc 1 cụm ≤ 3 file liên quan mật thiết** (5a: `AGENTS.md` + `glossary/decisions` → **dừng chờ review**; 5b: **đúng 1 file `SPEC-xx`** + `specs/README.md` → **dừng chờ review**; 5c: **1 file design/plan** → **dừng chờ review**); cấm viết toàn bộ cây docs trong 1 lượt. **Khi viết code (Bước 8):** mặc định 1 spec, 1 task/AC nhỏ; ghi điểm dừng trong `docs/progress.md`, xong thì báo bằng chứng và dừng chờ review.
8. **Nguồn & giới hạn hiểu biết (`C31`):** người dùng chốt hành vi/phạm vi; AI kiểm chứng kỹ thuật bằng repo, nguồn chính thức và thử nghiệm. Tách `Đã xác minh / Đề xuất / Chưa biết`; không tự chấm độ tin cậy %, bịa NFR, hay coi AI thứ hai là bằng chứng độc lập.
9. **Profile S:** mọi con trỏ `docs/specs/` → `docs/spec.md`/README, `docs/progress.md` → block đợt trong `AGENTS.md`; file glossary/decisions/plan chỉ đọc khi có. Áp dụng ánh xạ này ở mọi sub-skill/adapter; không sinh thêm file để thoả con trỏ.

## Chống ngụy biện (Red Flags — Dừng ngay nếu đang nghĩ)

| Ngụy biện dưới áp lực thời gian / uy quyền | Hành động bắt buộc |
|---|---|
| *"Dự án nhỏ / đang gấp, viết luôn `AGENTS.md` khỏi cần đề xuất Cổng 1"* | **Dừng.** Dự án nhỏ dùng Profile `S` (đề xuất gọn ~15 dòng), vẫn bắt buộc chốt Cổng 1 trước khi tạo file trong repo. |
| *"Chỉ thiếu vài chi tiết nhỏ, tự đoán luôn cho nhanh"* | **Dừng.** Đánh dấu `[CẦN LÀM RÕ]` hoặc hỏi theo `HYPOTHESIS + GUESS` ở Bước 4; tuyệt đối không bịa REQ/AC. |
| *"Tự đọc lại thấy ổn rồi, bỏ qua `spec-challenger` (Cổng 2) và `doc-tester` (Cổng 3)"* | **Dừng.** Người viết luôn mắc điểm mù xác nhận (`C26`); phải chạy kiểm tra context sạch và được người dùng duyệt mới sang bước tiếp. |
| *"Trình bày định hướng bằng đoạn chữ dài / chỉ báo 'All tests passed' là đủ"* | **Dừng.** Chữ dài gây "gật đầu mù" (`C28` — phải có Scope Radar, Mermaid + ASCII wireframe/I-O mẫu); báo test xanh mà giấu Input/Output/Mock là test hộp đen (`C29` — phải in Bảng Bằng chứng Chạy Test). |
| *"Đã qua Cổng 1 rồi, viết luôn một mạch toàn bộ `AGENTS.md`, `glossary`, `decisions` và tất cả các file `SPEC-xx` cho nhanh"* | **Dừng.** Vi phạm `C30`: mỗi lượt ở Bước 5 chỉ được viết **1 file hoặc 1 cụm ≤ 3 file liên quan** (5a → dừng chờ review → 5b từng spec một → dừng chờ review → 5c); cấm xả toàn bộ file docs rồi mới hỏi. |
| *"Mô tả trong bảng/YAML đã tóm tắt rồi, khỏi mở đọc file sub-skill"* | **Dừng.** YAML `description` chỉ là con trỏ kích hoạt; bắt buộc mở đọc `skills/<bước>/SKILL.md` trước khi làm. |

## Quy trình — bước nào mở sub-skill / subagent đó

| Bước | Việc | Sub-skill / Subagent | Cổng |
|---|---|---|---|
| 1–2 | Khảo sát dự án, thu bằng chứng, xác định mức 0/1/2, Profile & Pack | [skills/survey-project](skills/survey-project/SKILL.md) · subagent [`spec-surveyor`](agents/spec-surveyor.md) | |
| 3 | Đề xuất thiết kế docs + Capability Map (chưa tạo file repo) | [skills/propose-doc-design](skills/propose-doc-design/SKILL.md) | **Cổng 1 — chờ duyệt** |
| 4 | Làm rõ theo Frontier + `HYPOTHESIS/GUESS`; đáp án → `D-xx` hoặc spec | (nội quy trong `propose-doc-design` §3) | |
| 5a | Viết cụm nền tảng: `AGENTS.md` (+ `CONSTRAINTS.md`), `glossary`, `decisions` | [templates/](templates/) + `principles.md` §4.2 | **Checkpoint 5a — chờ review cụm file này** |
| 5b | Viết `specs/README.md` + **đúng 1 file `SPEC-xx` sắp làm** (từng spec một) | [skills/write-spec](skills/write-spec/SKILL.md) | **Checkpoint 5b — chờ review từng spec** |
| 5c | Viết **1 file design doc** (Deep Modules, Seams, Design It Twice) khi có tín hiệu | [skills/write-design-doc](skills/write-design-doc/SKILL.md) | **Checkpoint 5c — chờ review design** |
| 6 | Phản biện đối kháng & chấm checklist | [skills/review-docs](skills/review-docs/SKILL.md) · subagent [`spec-challenger`](agents/spec-challenger.md) | **Cổng 2 — chờ duyệt** |
| 7 | Thử docs bằng 2–3 task mẫu trong phiên sạch | [skills/test-docs](skills/test-docs/SKILL.md) · subagent [`doc-tester`](agents/doc-tester.md) | **Cổng 3 — chờ duyệt mới code** |
| 7.5 | Chọn lát cắt, AC, kiểm chứng và điểm dừng; plan riêng/skill verify chỉ khi cần | [skills/plan-tasks](skills/plan-tasks/SKILL.md) · [skills/generate-verify-harness](skills/generate-verify-harness/SKILL.md) | |
| 8 | Code theo quy trình bộ docs định nghĩa; quản lý thay đổi spec | [skills/change-spec](skills/change-spec/SKILL.md) | |

Luật xuyên các bước:

- Bước 4: nêu `HYPOTHESIS` + bằng chứng và khoảng trống; tối đa 3 câu về kết quả/đánh đổi trên **Frontier**, kèm đề xuất. Chi tiết kỹ thuật có thể uỷ quyền thì AI tự nghiên cứu trong phạm vi đã giao (`C31`).
- Bước 5: chép mẫu từ `templates/`, điền giá trị thật, xoá phần không áp dụng; không để placeholder trong file giao; lệnh trong `AGENTS.md` / `CONSTRAINTS.md` phải chạy được. Spec mới `Draft`; brownfield `As-built` kèm bằng chứng; chỉ người dùng chuyển `Ready`.
- Bước 8: phát hiện docs sai/thiếu khi code → dừng, đề xuất sửa docs trước; spec đã `Done` thì qua [skills/change-spec](skills/change-spec/SKILL.md).

## Sau khi code chạy (bảo trì)

- Luật vi phạm ≥ 2 lần → đưa vào `CONSTRAINTS.md` / lint / test / hook, thông báo lỗi kèm ID luật + cách sửa; rút văn xuôi.
- Quy trình lặp ≥ 2 lần hoặc cần kiểm chứng runtime tự động → dùng [skills/generate-verify-harness](skills/generate-verify-harness/SKILL.md) hoặc [templates/project-skill](templates/project-skill/SKILL.md).
- Lỗi khó đã gặp → gotchas kèm ngày kiểm lần cuối (`C18`); chưa sửa thì có issue.
- Khi ngữ cảnh phiên dài (≥ 20 lượt / ~30k tokens), chuyển Cổng 3 → Bước 8, hoặc `docs/progress.md > 5 KB` / `AGENTS.md > 150 dòng` (`C32` · hook [scripts/context-guard.ps1](scripts/context-guard.ps1)): tự bật `Auto-Caveman` nén phản hồi, in `[CẢNH BÁO TOKEN & NGỮ CẢNH — C32]`, chắt lọc tri thức quan trọng vào `decisions.md` + `progress.md` (lưu trữ phần cũ vào `progress-archive/`) + `HANDOFF.md` rồi nhắc `/compact` hoặc mở phiên mới.
- Làm xong P-xx → chuyển D-xx hoặc xoá. Spec chỉ `Done` khi mọi AC còn hiệu lực của spec `[x]` có bằng chứng, không chỉ AC của đợt; `[~]` chưa kiểm chứng.
