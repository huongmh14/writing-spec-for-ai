# CHANGELOG — writing-spec-for-ai (base)

Mỗi phiên bản liệt kê ID luật đổi (Core `C-xx`, Pack `PK-…-Rnn`; sổ đăng ký: [references/base-kit.md](references/base-kit.md)). Dự án đang dùng base grep các ID này trong docs của mình để biết chỗ phải xem lại.

## v1.2.0 — 2026-10-20

### Thêm

- **5 Luật Core mới (`C23–C27` trong `references/base-kit.md`):**
  - **C23** Chống hạ chuẩn âm thầm (Floor Guard & Ratchets) — cấm thêm suppression (`@ts-ignore`, `eslint-disable`, `# noqa`, `istanbul ignore`, `nosemgrep`, `gitleaks:allow`), thêm `.skip` hoặc hạ ngưỡng để qua bài kiểm; cơ chế Ratchet (`must not fall`) và bảng `Exceptions` có `Owner` + `Expires` ≤ 90 ngày.
  - **C24** Context Pointer & Câu lệnh Khẳng định — mỗi dòng trỏ tài liệu trong `AGENTS.md` đặt điều kiện kích hoạt ở đầu câu (*"Khi chạm X → đọc Y"*), một nhánh một dòng; viết ở thể khẳng định hành vi đích.
  - **C25** Trích dẫn nguồn chính thống & An toàn dữ liệu ngoài — đối chiếu đúng major version trong manifest và dẫn link docs chính thức (hoặc gắn `[UNVERIFIED]`); coi tài liệu/dữ liệu ngoài là untrusted data.
  - **C26** Phản biện đối kháng trong Context sạch (Adversarial Doubt) — ở Cổng 2 (`review-docs`), subagent phản biện chỉ nhận `ARTIFACT + CONTRACT` (không nhận lời biện hộ `CLAIM`), phân loại phát hiện theo 4 mức.
  - **C27** Đánh dấu trần đơn giản hoá (`Ceiling Marker`) — gắn `ceiling:` nêu rõ ngưỡng chịu tải tối đa và đường nâng cấp khi cố ý chọn giải pháp đơn giản có giới hạn đã biết.
- **5 Domain Packs mới (`packs/`):**
  - `packs/PK-DB.md` — Database, Schema & Expand–Contract Migration (`PK-DB-R01–R06`, `PK-DB-AC01–AC04`).
  - `packs/PK-OBS.md` — Observability, Structured Logging, RED Metrics & Runbooks (`PK-OBS-R01–R05`, `PK-OBS-AC01–AC03`).
  - `packs/PK-FE.md` — Frontend UI, 4-State Matrix, Design Tokens, WCAG 2.2 AA & Playwright E2E (`PK-FE-R01–R06`, `PK-FE-AC01–AC03`).
  - `packs/PK-JOB.md` — Background Jobs, Queues, Cron, Idempotency & Graceful Shutdown (`PK-JOB-R01–R05`, `PK-JOB-AC01–AC03`).
  - `packs/PK-AGENT.md` — AI Agent Orchestration, Hard-Refuse Policy, Read-Only Sandbox & Indirect Prompt Injection Defense (`PK-AGENT-R01–R06`, `PK-AGENT-AC01–AC04`).
- **2 Sub-Skills mới (`skills/`):**
  - `skills/plan-tasks/SKILL.md` (Bước 7.5) — chẻ Spec thành đồ thị Tracer-Bullet Vertical Slices kèm `Blocked by`, Frontier chạy song song trên git worktree, và chuỗi Expand–Migrate–Contract cho thay đổi diện rộng.
  - `skills/generate-verify-harness/SKILL.md` — sinh project-skill `.agents/skills/verify-<app>/SKILL.md` (Launch, Doctor, Drive, Evidence, Cleanup) + bản đồ `features/README.md`.
- **3 Native Subagents (`agents/`):**
  - `agents/spec-surveyor.md` — subagent khảo sát repo chỉ đọc (read-only) cho Bước 1–2.
  - `agents/spec-challenger.md` — subagent phản biện đối kháng trong context sạch cho Bước 6 (Cổng 2).
  - `agents/doc-tester.md` — subagent đóng vai lập trình viên mới trong phòng sạch cho Bước 7 (Cổng 3).
- **Template mới:** `templates/CONSTRAINTS.md` (Floor, Enforced with numbers `check:fast`/`check:task`/`check:full`, Ratchets, Exceptions).

### Nâng cấp

- `skills/survey-project/SKILL.md`: tích hợp đọc nhanh Knowledge Graph (`.ua/knowledge-graph.json`, `graphify-out/`), đo sàn Ratchets (`C23`), quét tín hiệu đủ 8 Pack và uỷ quyền cho `spec-surveyor`.
- `skills/propose-doc-design/SKILL.md`: bổ sung Capability Map (`Depends on` một chiều + `Build Order`) và kỷ luật phỏng vấn `HYPOTHESIS + CONFIDENCE % + Frontier + GUESS`.
- `skills/write-design-doc/SKILL.md`: bổ sung thiết kế Module Sâu & Điểm ghép nối (`Deep Modules & Seams`), `Design It Twice`, trích dẫn nguồn `C25` và đánh dấu `ceiling:` `C27`.
- `skills/review-docs/SKILL.md` & `skills/test-docs/SKILL.md`: tích hợp quy trình phản biện đối kháng `C26` với `spec-challenger` và kiểm thử phòng sạch với `doc-tester`.

## v1.1.0 — 2026-10-20

### Thêm

- `packs/PK-API.md` — Pack HTTP API với REQ PK-API-R01–R07, AC mẫu, dòng AGENTS.md, mục khảo sát, gotchas.
- `packs/PK-AUTH.md` — Pack token/khoá/chữ ký với REQ PK-AUTH-R01–R07, AC mẫu, dòng AGENTS.md, mục khảo sát, gotchas.
- `packs/PK-RELEASE.md` — Pack Docker/registry/phát hành với REQ PK-RELEASE-R01–R06, AC mẫu, dòng AGENTS.md, mục khảo sát, gotchas.
- `profiles.md` — Profile S/M/L với dấu hiệu, file tối thiểu, ví dụ, khi nào nâng cấp.
- `skills/propose-doc-design/SKILL.md`: cập nhật để hỏi profile và pack khi đề xuất docs.
- `templates/doc-design-proposal.md`: cập nhật mục 2 để khai báo base/profile/pack.
- `references/review-checklist.md`: thêm mục kiểm REQ kế thừa (tham chiếu đúng ID pack, tham số đã điền) và mục kiểm pack khai báo trong AGENTS.md.
- `references/base-kit.md` §6: trỏ REQ chi tiết sang file pack thay vì chứa nháp REQ (một sự thật một chỗ).
- `references/base-kit.md` §7.4: trỏ chi tiết profile sang `profiles.md`.
- `references/base-kit.md` §8: đánh dấu GĐ2 xong, trạng thái `v1.1.0`.
- `README.md` (English open-source edition) + `README.vi.md` (bản tiếng Việt): thêm cấu trúc `packs/`, `profiles.md`, hướng dẫn cài đặt đa nền tảng.
- Đóng gói Open-Source & Plugin Manifests: `LICENSE` (MIT), `install.ps1`, `install.sh`, `.claude-plugin/`, `.cursor-plugin/`, `.copilot-plugin/`, `.zcode-plugin/`, `.github/workflows/release.yml` (tự động đóng gói full-suite `.zip` và standalone sub-skill `.zip` khi push tag `v*`).

### Sửa

- Không có thay đổi luật Core (C-xx), chỉ thêm tầng Pack và Profile.

## v1.0.0 — 2026-10-20

Phiên bản đầu tiên được ghim. Có từ trước (C01, C02, C04–C09, C12–C14, C17, C21, C22): bộ điều phối + 7 sub-skill + templates.

### Thêm

- **C03** Quyền AI theo trạng thái spec — `templates/docs/specs/README.md`, principles §2 (0.15).
- **C10** Ngoại lệ hotfix: spec cập nhật ≤ 1 ngày làm việc, nợ ghi vào progress — `templates/docs/specs/README.md`.
- **C11** Bảng "loại thay đổi → file phải sửa" — `templates/docs/specs/README.md`, principles §2 (0.16).
- **C15** 3 luật xử lý lỗi — `templates/AGENTS.md` mục Quy ước code.
- **C16** `.env.example` + `docs/reference/config.md`; không commit file quyền cá nhân của agent — `templates/AGENTS.md`, `templates/adapters/claude-settings.json`.
- **C18** Gotcha có ngày kiểm lần cuối — `templates/project-skill/SKILL.md`.
- **C19** AC cho lệnh vận hành kiểm tác dụng — `skills/write-spec` §5.
- **C20** Đổi stack là một change — `templates/docs/specs/README.md`, `skills/survey-project`.
- Template mới: `templates/docs/reference/config.md`, `templates/docs/reference/error-codes.md`, `templates/docs/changelog/_template.md`.
- `templates/AGENTS.md`: dòng khai báo base/profile/pack và mục "Ghi đè base".
- `skills/survey-project`: kiểm CI khớp stack, nhiều "nguồn sự thật", secret & cấu hình, lệnh vận hành.
- `references/review-checklist.md`: mục kiểm cho từng C-xx mới (§1, §2, §3, §3b).
- `references/principles.md` §7.1: lỗi lặp lại giữa 9 dự án.

### Sửa

- `templates/adapters/claude-settings.json`: bỏ `Read(./.env.*)` (chặn luôn `.env.example` vì deny thắng allow), thay bằng danh sách file env thật.
