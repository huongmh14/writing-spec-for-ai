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

**Dấu hiệu:** Có API công khai, hoặc worker background, hoặc DB tự quản lý. Quy mô trung bình (~50–200 file).

**File tối thiểu:**
- Toàn bộ mức 0 (Core):
  - `AGENTS.md` (đầy đủ theo template).
  - `README.md`.
  - `.env.example`.
  - `docs/reference/config.md` — bảng biến môi trường.
  - `docs/reference/error-codes.md` — danh mục mã lỗi.
- Mức 1 — theo tín hiệu:
  - `docs/specs/` — spec theo khu vực (6–12 spec).
  - `docs/decisions.md` — quyết định đã chốt.
  - `docs/glossary.md` — thuật ngữ.
  - `docs/progress.md` — bộ nhớ phiên.
  - `docs/plans/` — plan/handoff khi cần.
  - `docs/changelog/` — changelog theo version.
- Pack — theo tín hiệu:
  - `PK-API` nếu có endpoint HTTP.
  - `PK-AUTH` nếu có xác thực.
  - `PK-RELEASE` nếu có Docker/binary phát hành.
  - Pack khác (PK-TENANT, PK-JOB, PK-DB) theo tín hiệu.
- CI:
  - Chạy DoD (lint + typecheck + test) trên PR.
  - Build/test khi tag.

**Ví dụ:**
- `cdn` — Fastify + Kysely + PG + Redis, có API, auth, release.
- `notification-service` — NestJS + Prisma + Redis + RabbitMQ, có API, auth, release.
- `khaosatvmu` — .NET + React + worker, có DB, release.
- `citad-vmu-resources` — Node + ESLint, có release.
- `BotAutoTask` — Node ESM + Cloudflare Workers/D1, có auth, release.

**Khi nào nâng lên L:**
- Monorepo với nhiều package.
- Có dự án phía dưới phụ thuộc.
- Cần luật theo phạm vi, upgrade/compatibility, cưỡng chế bằng máy.

---

## Profile L — Nền tảng, monorepo

**Dấu hiệu:** Nhiều package/service, có dự án phía dưới phụ thuộc, hoặc monorepo lớn (>200 file).

**File tối thiểu:**
- Toàn bộ Profile M.
- Mức 2 — theo tín hiệu:
  - `docs/architecture/` — kiến trúc tổng thể, diagram.
  - `docs/upgrade/` — hướng dẫn nâng cấp từng version.
  - `.agents/skills/<tên>/SKILL.md` — skill dự án khi có logic riêng.
  - Cưỡng chế, hook, CODEOWNERS, ruleset.
  - Law of Demeter theo phạm vi.
  - Contract machine-readable (OpenAPI, schema).

**Ví dụ:**
- `dashboard` — NestJS + Quasar + Prisma, monorepo, nhiều module.

---

## Chọn profile

Đầu tiên chạy `survey-project` sub-skill để phát hiện tín hiệu, rồi chọn profile phù hợp. Profile có thể nâng lên nhưng không nên hạ xuống (đã docs thì giữ).

**Ghi trong đề xuất docs (doc-design-proposal.md):**
```
- Base: writing-spec-for-ai v1.1 · Profile: M · Pack: PK-API, PK-AUTH, PK-RELEASE
```

**Ghi trong AGENTS.md (đầu file):**
```md
> Base: writing-spec-for-ai v1.1 · Profile: M · Pack: PK-API, PK-AUTH, PK-RELEASE
> Ghi đè base: xem mục "Ghi đè" cuối file.
```
