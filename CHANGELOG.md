# CHANGELOG — writing-spec-for-ai (base)

Mỗi phiên bản liệt kê ID luật đổi (Core `C-xx`, Pack `PK-…-Rnn`; sổ đăng ký: [references/base-kit.md](references/base-kit.md)). Dự án đang dùng base grep các ID này trong docs của mình để biết chỗ phải xem lại.

## Chưa phát hành — 2026-10-26

- **C30 — Quyền thực thi theo đợt & Checkpoint soạn thảo (`5a` / `5b` / `5c`):** `Ready`/plan không cấp quyền chạy backlog; mặc định 1 spec/1 task, có bằng chứng và điểm dừng. Khi viết bộ docs dự án, mỗi lượt chỉ làm **một bước con** rồi dừng chờ review (`5a` cụm nền; `5b` đúng 1 `SPEC-xx.md`; `5c` 1 design). Batch hữu hạn đã giao được làm đủ, không hỏi lại. Một block RUN trong progress; HANDOFF/subagent không mở rộng quyền.
- **C31 — Nguồn & giới hạn hiểu biết:** bản đọc ngắn bằng hành vi; REQ/NFR có cơ sở và trạng thái kiểm chứng. Bỏ tự chấm confidence %, không bịa ngưỡng; AI kiểm kỹ thuật trong quyền đã giao, cần chuyên môn thì nêu cách kiểm và phần bị chặn.
- **C32 — đã bỏ trước khi phát hành:** Auto-Caveman, banner cảnh báo token và hook `context-guard` thuộc việc quản lý phiên của công cụ AI, không thuộc spec; ước lượng token sai với tiếng Việt và `install` tự sửa cấu hình `~/.claude` / `~/.cursor` của người dùng. Phần ghi tri thức phiên đã có ở `C17`. ID `C32` không dùng lại. Ai đã chạy `install` bản dev trước đó: xoá mục `context-guard` trong `~/.claude/settings.json` (`UserPromptSubmit`) và `~/.cursor/hooks.json` (`preToolUse`), xoá `~/.agents/hooks/context-guard.*`, `~/.claude/hooks/context-guard.*`.
- **Dễ đọc & kiểm chứng được:** thêm [references/glossary.md](references/glossary.md) (thuật ngữ quy trình, trạng thái/ID, khái niệm mượn kèm nguồn gốc). Quy tắc "nghĩa trước, mã sau": `templates/` không còn mã luật `Cxx`; file nội bộ ghi tên ngắn ở lần đầu nhắc luật. `C31` dùng 4 nhãn nguồn gốc `Người dùng chốt / Đã xác minh / AI đề xuất / Chưa biết`, `Đã xác minh` phải kèm con trỏ mở được + trích nguyên văn; thêm **thẻ quyết định kỹ thuật** (bước tự kiểm ≤ 5 phút, "cần chuyên gia" cho vùng đắt kiểm) vào mẫu spec/design; `spec-challenger` mở từng nguồn để đối chiếu câu trích.
- **Sửa mâu thuẫn nội bộ:** một thứ tự nguồn sự thật (`C01`); số task mẫu Cổng 3 là 2–3 (S: 2, M/L: 3); "Frontier" chỉ còn một nghĩa (task hết bị chặn đổi tên thành "task sẵn sàng"); migration thống nhất tên Expand–Migrate–Contract; ngưỡng Profile liền mạch; ngưỡng không có nguồn ghi là quy ước của bộ kit; bỏ đường dẫn máy cá nhân, ghi rõ khảo sát 9 repo là nguồn nội bộ.
- **`scripts/validate.ps1`:** thêm kiểm `templates/` không chứa mã luật `Cxx`, kit không chứa đường dẫn `D:\`, `templates/AGENTS.md` ≤ 150 dòng, glossary tồn tại; bỏ eval-14 (C32).
- **Sửa C03/C05/C13:** duyệt yêu cầu tách khỏi quyền chạy; `[~]` chưa đủ `Done`. Chỉ chi tiết hoá spec sắp làm, bỏ chỉ tiêu 10–25 REQ. Đổi nghĩa spec Ready qua change-spec.
- Đồng bộ luồng, template, reviewer/tester, checklist; thêm [nghiên cứu](references/research-controlled-execution.md), [bản thử](references/controlled-spec-demo.md), eval 07–13 và kiểm cấu trúc (`scripts/validate.ps1` hỗ trợ cả cấu trúc repo nguồn lẫn cấu trúc phẳng đã cài).

## v1.3.0 — 2026-10-20

### Thêm (Giải quyết Điểm mù Định hướng & Kiểm thử Hộp đen)

- **2 Luật Core mới (`C28–C29` trong `references/base-kit.md` & `references/principles.md` §2):**
  - **C28 — Trực quan hoá Định hướng & Phương án (`Visual Direction & Option Cards`):** cấm trình bày định hướng sản phẩm/kiến trúc chỉ bằng chữ dài dễ gây "gật đầu mù" (*rubber-stamping*). Bắt buộc có:
    1. **Scope Radar (`🟢 Làm ngay (MVP) / 🟡 Đợt kế (Phase 2) / 🔴 Không làm`)** ngay ở Cổng 1 (`propose-doc-design`).
    2. **Luồng tương tác trực quan (`Mermaid User Journey / State Flow`)** + **Snapshot I/O cụ thể** (ASCII UI wireframe, mẫu CLI, hoặc JSON request/response thực tế) trong mọi `SPEC-xx`.
    3. **2–3 Phương án trực quan (`Visual Option Cards`)** kèm đánh đổi khi hướng phát triển còn mở để người dùng nhìn thấy và chọn trước khi viết spec.
  - **C29 — Minh bạch hoá & Trực quan hoá Kiểm thử (`Visible Test Plan & Execution Ledger`):** cấm chạy test ngầm dạng hộp đen rồi chỉ báo *"All tests passed"*. Bắt buộc 2 lớp minh bạch:
    1. **Trước khi code (`Visible Test Matrix` trong `SPEC-xx` & `plan-tasks`):** bảng đối chiếu từng `AC-ID` với `Đầu vào cụ thể (Input)`, `Kỳ vọng quan sát được (Output & Tác dụng phụ DB/DOM)`, và **`Tầng & Độ thật (Mock Disclosure: 0 Mock hay Mock thành phần nào)`**.
    2. **Sau khi chạy test (`Visible Test Execution Ledger` trong DoD của `AGENTS.md`, mẫu PR `pull_request_template.md`, và skill `verify-<app>`):** bắt buộc in bảng kết quả thực tế cho từng `AC-ID` để lập trình viên thấy rõ AI đã test cái gì và có tự mock mất logic thật hay không.
- **Ví dụ chuẩn & Kịch bản Đánh giá (`references/examples.md` §8–9, `evals/evals.json`):** bổ sung mẫu Scope Radar, ASCII wireframe + payload, bảng `Visible Test Execution Ledger` thực tế và kịch bản benchmark `eval-06-visual-direction-and-visible-testing`.
- **Nâng cấp Templates, Sub-Skills, Subagents & Validator (`scripts/validate.ps1`):** cập nhật đồng bộ `propose-doc-design`, `write-spec`, `plan-tasks`, `generate-verify-harness`, `review-docs`, `spec-challenger`, `doc-tester`, `templates/` và thêm kiểm tra tự động các marker `C28`/`C29`.

## v1.2.2 — 2026-10-20

### Sửa lỗi & Đồng bộ kiến trúc

- **Cài đặt phẳng 9 Sub-Skills ở cấp 1 (`install.ps1` & `install.sh`):**
  - Ngoài skill điều phối `writing-spec-for-ai`, trình cài đặt nay giải phẳng cả 9 sub-skills (`survey-project`, `propose-doc-design`, `write-spec`, `write-design-doc`, `change-spec`, `review-docs`, `test-docs`, `plan-tasks`, `generate-verify-harness`) ra thư mục gốc `<agent-skills-dir>/<sub-skill>/` kèm chuẩn hoá đường dẫn tương đối (`../../` → `./`) để mọi AI IDE/CLI phát hiện và gọi trực tiếp được từng sub-skill.
  - Sửa lỗi `install.ps1` khi chạy one-liner `irm ... | iex` trong thư mục dự án vô tình có sẵn file `SKILL.md`.
- **Đồng bộ cấu trúc giữa Templates và Sub-Skills:**
  - `templates/doc-design-proposal.md`: bổ sung cột `Depends on` + `Build Order` (Capability Map), bảng kế thừa Pack `PK-*`, và khung phỏng vấn `HYPOTHESIS + CONFIDENCE % + Frontier + ➡️ GUESS`.
  - `templates/docs/specs/_template.md`: bổ sung bảng kế thừa REQ từ Domain Pack (`PK-*-Rnn` + tham số `{…}`).
  - `templates/docs/specs/_design-template.md`: bổ sung bảng **Deep Modules & Seams** (`Interface & Seam`, `Depth`, nguồn `C25` / `ceiling:` `C27`), migration `Expand–Contract` (`PK-DB-R01`), và bảng so sánh **Design It Twice** (`Interface Depth`, `Locality`).
  - `templates/docs/plans/_plan-template.md`: nâng cấp thành đồ thị **Tracer-Bullet Task Graph** (`T-01`, `Blocked by`, `Frontier`, lệnh `Verify` và context pointers cho subagent).
- **Đồng bộ Plugin Manifests & Validator (`scripts/validate.ps1`):**
  - `.cursor-plugin/plugin.json`, `.copilot-plugin/plugin.json`, `.zcode-plugin/plugin.json`: khai báo đầy đủ mảng 10 skills (gồm cả `./`) và 3 subagents.
  - `scripts/validate.ps1`: kiểm tra thêm `marketplace.json`, `claude-settings.json`, đồng bộ `version` trên toàn bộ manifest, và kiểm tra các marker cấu trúc bắt buộc trong `templates/`.

## v1.2.1 — 2026-10-20

### Nâng cấp (SDO, Chống ngụy biện, Benchmark & Kiểm định tự động)

- **Chuẩn hoá SDO (Skill Discovery Optimization) cho 10 `SKILL.md` và 3 `agents/*.md`:**
  - Đặt điều kiện kích hoạt (*"Kích hoạt khi..."* / *"Dùng ở Bước..."* / *"Use when..."*) lên đầu mọi trường `description` (tuân thủ luật `C24` và chuẩn `agentskills.io`).
  - Loại bỏ tóm tắt quy trình làm việc (workflow spoilers) khỏi `description` để ngăn lỗi AI agent đọc lướt `description` rồi tự làm tắt mà không mở đọc file `SKILL.md`.
  - Giảm **31,5%** chi phí token metadata thường trực trong system prompt (từ 4.426 ký tự xuống 3.035 ký tự cho cả 10 skills).
- **Bảng Chống ngụy biện (`Red Flags`) trong `SKILL.md`:** khoá chặt 3 Cổng duyệt trước tổ hợp áp lực Thời gian + Uy quyền + Chi phí chìm (*"dự án nhỏ viết luôn khỏi qua Cổng 1"*, *"tự đoán chỗ thiếu"*, *"bỏ qua `spec-challenger`/`doc-tester`"*).
- **Bộ kịch bản đánh giá chuẩn `evals/evals.json`:** 5 kịch bản benchmark (Greenfield Profile `S`, Brownfield Backend `As-built`, Multi-Agent Orchestrator, Pressure Resistance, Fresh-Context Adversarial Review) + ma trận kiểm thử điều hướng SDO 9 sub-skills.
- **Cổng kiểm định tự động `scripts/validate.ps1` & GitHub Actions `.github/workflows/validate.yml`:** kiểm tra tự động YAML frontmatter, chuẩn SDO Trigger-First (`≤ 450` ký tự), trần số dòng (Ratchets), 0 liên kết nội bộ gãy, 0 ký tự lạ sai bảng mã, và JSON schema hợp lệ.

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
