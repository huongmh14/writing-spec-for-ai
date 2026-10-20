# Profile — preset cho repo theo quy mô

Profile là điểm xuất phát để repo nhỏ không gánh chi phí docs của repo lớn. Chỉ là preset, tín hiệu mức 1–2 (principles §2) vẫn quyết định thêm gì.

## Profile S — Script, hạ tầng

**Dấu hiệu:** < ~30 file, không có API công khai, thường là script, config, hạ tầng.

**File tối thiểu:**
- `AGENTS.md` (≤ 60 dòng) — chỉ mục Lệnh, Nguồn sự thật, Ranh giới, DoD.
- `README.md` — mô tả dùng làm gì, cách chạy.
- `.env.example` — đủ mọi biến, không giá trị thật.
- `docs/spec.md` (tùy chọn) — một file spec nếu có hành vi cần nghiệm thu (≤ 10 REQ).

**Không bắt buộc:**
- `docs/specs/` thư mục (chỉ cần `docs/spec.md` nếu có).
- `docs/decisions.md` (chỉ khi đã có ≥ 2 quyết định).
- `docs/glossary.md` (chỉ khi có thuật ngữ đặc thù).
- `CONSTRAINTS.md` (chỉ cần sàn cứng trong `AGENTS.md`).
- CI bắt buộc chạy DoD (có thể chạy thủ công).

**Ví dụ:**
- `vmu-deploy-tool` — shell script + crontab.
- `citad-postgresql` — Docker Compose PostgreSQL.
- `citad-crawler-work-schedule` — Python script nhỏ.

**Khi nào nâng lên M:**
- Tạo API/worker/DB tự quản lý.
- Số file > ~30.
- Cần nhiều spec chia khu vực.

---

## Profile M — Dịch vụ

**Dấu hiệu:** Có API công khai, hoặc worker background, hoặc DB tự quản lý, hoặc orchestrator AI agent. Quy mô trung bình (~50–200 file).

**File tối thiểu:**
- Toàn bộ mức 0 (Core `C01–C29`):
  - `AGENTS.md` (đầy đủ theo template).
  - `README.md`.
  - `.env.example`.
  - `docs/reference/config.md` — bảng biến môi trường.
  - `docs/reference/error-codes.md` — danh mục mã lỗi.
- Mức 1 — theo tín hiệu:
  - `CONSTRAINTS.md` — sàn chất lượng được kiểm bằng lệnh máy (`check:fast`, `check:task`, `check:full`) và bảng Ratchets (`C23`).
  - `docs/specs/` — spec theo khu vực (6–12 spec) kèm `Capability Map` trong `docs/specs/README.md`.
  - `docs/decisions.md` — quyết định đã chốt.
  - `docs/glossary.md` — thuật ngữ miền.
  - `docs/progress.md` — bộ nhớ phiên.
  - `docs/plans/` — đồ thị task Tracer Bullets (`plan-tasks`) / handoff khi cần.
  - `docs/changelog/` — changelog theo version.
- Pack — theo tín hiệu (từ 8 pack trong `packs/`):
  - `PK-API` nếu có endpoint HTTP.
  - `PK-AUTH` nếu có xác thực, API key, chữ ký webhook.
  - `PK-RELEASE` nếu có Docker/binary phát hành.
  - `PK-DB` nếu có DB tự quản lý, ORM, migration.
  - `PK-OBS` nếu cần structured logging, RED metrics, cảnh báo + runbook.
  - `PK-FE` nếu có giao diện người dùng (Web/Desktop/Dashboard).
  - `PK-JOB` nếu có worker, queue consumer, cron/scheduler.
  - `PK-AGENT` nếu hệ thống điều phối AI agent, gọi LLM/CLI harness, chạy lệnh do AI sinh ra.
- CI:
  - Chạy DoD (lint + typecheck + test + floor guard) trên PR.
  - Build/test khi tag.

**Ví dụ:**
- `cdn` — Fastify + Kysely + PG + Redis (`PK-API, PK-AUTH, PK-DB, PK-OBS, PK-JOB, PK-RELEASE`).
- `notification-service` — NestJS + Prisma + Redis + RabbitMQ (`PK-API, PK-AUTH, PK-DB, PK-OBS, PK-JOB, PK-RELEASE`).
- `khaosatvmu` — .NET + React + worker (`PK-API, PK-DB, PK-FE, PK-JOB, PK-RELEASE`).
- `citad-vmu-resources` — Node + ESLint (`PK-RELEASE`).
- `BotAutoTask` — Node ESM + Cloudflare Workers/D1 (`PK-API, PK-AUTH, PK-DB, PK-JOB, PK-RELEASE, PK-AGENT`).

**Khi nào nâng lên L:**
- Monorepo với nhiều package.
- Có dự án phía dưới phụ thuộc.
- Cần luật theo phạm vi, upgrade/compatibility, cưỡng chế bằng máy.

---

## Profile L — Nền tảng, monorepo

**Dấu hiệu:** Nhiều package/service, có dự án phía dưới phụ thuộc, hoặc monorepo lớn (>200 file).

**File tối thiểu:**
- Toàn bộ Profile M (`CONSTRAINTS.md` bắt buộc).
- Mức 2 — theo tín hiệu:
  - `docs/architecture/` — kiến trúc tổng thể, diagram.
  - `docs/upgrade/` — hướng dẫn nâng cấp từng version.
  - `.agents/skills/verify-<app>/SKILL.md` — skill kiểm chứng tự động (`generate-verify-harness`).
  - `.agents/skills/<tên>/SKILL.md` — skill dự án khi có quy trình riêng lặp ≥ 2 lần.
  - Cưỡng chế, hook, CODEOWNERS, ruleset.
  - Luật theo phạm vi thư mục (`scoped-rules.md`).
  - Contract machine-readable (OpenAPI, JSON Schema).

**Ví dụ:**
- `dashboard` — NestJS + Quasar + Prisma, monorepo, nhiều module (`PK-API, PK-AUTH, PK-DB, PK-OBS, PK-FE, PK-RELEASE`).

---

## Chọn profile

Đầu tiên chạy `survey-project` sub-skill (hoặc subagent `spec-surveyor`) để phát hiện tín hiệu, rồi chọn profile phù hợp. Profile có thể nâng lên nhưng không nên hạ xuống (đã có docs thì giữ).

**Ghi trong đề xuất docs (doc-design-proposal.md):**
```
- Base: writing-spec-for-ai v1.3.0 · Profile: M · Pack: PK-API, PK-AUTH, PK-DB, PK-RELEASE
```

**Ghi trong AGENTS.md (đầu file):**
```md
> Base: writing-spec-for-ai v1.3.0 · Profile: M · Pack: PK-API, PK-AUTH, PK-DB, PK-RELEASE
> Ghi đè base: xem mục "Ghi đè" cuối file.
```
