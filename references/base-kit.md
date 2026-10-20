# Base kit — phần kế thừa 100% và hướng phát triển base cho mọi dự án

> Trạng thái: **Đã duyệt 2026-10-20**. GĐ1 xong ở base `v1.0.0` (xem [CHANGELOG.md](../CHANGELOG.md)).
> Nguồn: khảo sát 9 repo thật (`D:\Workspace\VMU\*` + `D:\BotAutoTask`), đối chiếu với [principles.md](principles.md).
> File này là **sổ đăng ký ID Core (C-xx) và Pack (PK-…)** + lý do kế thừa. *Cách viết* vẫn nằm ở `principles.md`, `templates/`, `skills/`.

## Mục lục

1. Khảo sát 9 dự án
2. Tiêu chí "kế thừa 100%" và 4 tầng
3. Tầng Core — kế thừa nguyên văn
4. Tầng Tham số — khung cố định, giá trị riêng
5. Lỗi lặp lại giữa các dự án (bằng chứng cho Core)
6. Tầng Pack — kế thừa có điều kiện
7. Mô hình tuỳ biến
8. Lộ trình phát triển
9. Cố ý không làm
10. Làm rõ
11. Câu hỏi mở

---

## 1. Khảo sát 9 dự án

| Repo | File (git) | Stack | Docs cho AI / spec | CI | Commit | Profile đề xuất |
|---|---|---|---|---|---|---|
| dashboard | 695 | NestJS + Quasar + Prisma, monorepo | `AGENTS.md`, `CLAUDE.md`, `decisions.md`, spec có ID | ci, deploy, release, pr-policy, rulesets, commitlint, husky, CODEOWNERS | Conventional + `[SPEC-X]` | L |
| notification-service | 366 | NestJS + Prisma + Redis + RabbitMQ (+ legacy .NET) | `SPECS/WORKFLOW/CONVENTIONS/ARCHITECTURE/PRODUCT.md`, `features/v2/`, `knowledge.md` | ⚠ `ci.yml` gọi `Notification.slnx` không còn trong repo | Conventional | M |
| khaosatvmu | 617 | .NET (sln) + React/Vite + worker | Chỉ docs giải thích thuật toán | deploy | Lẫn lộn (`new fix 2509`) | M |
| cdn | 111 | Fastify 5 + Kysely + PG + Redis + RustFS | `SPECS/WORKFLOW/CONVENTIONS/ARCHITECTURE.md`, `features/v1/`, skill, `.devin/TASK.md` | Không có | Lẫn lộn (`fix`, `update …`) | M |
| BotAutoTask | ~75 | Node ESM + Cloudflare Workers/D1 | `docs/feature/01–08`, research; không có `AGENTS.md` | Chỉ build khi có tag | Conventional | M |
| citad-vmu-resources | 68 | Node + ESLint | Không có | docker-release (tag `release/v*`) | Tiếng Việt tự do | M |
| citad-crawler-work-schedule | 15 | Python | README | Không có | Tiếng Việt tự do | S |
| citad-postgresql | 9 | Docker Compose PG | README | Không có | Tự do | S |
| vmu-deploy-tool | 8 | Shell + crontab | README | Không có | Tự do | S |

**Kết luận:**

1. **Thứ có ở mọi repo chỉ gồm:** README, file env mẫu, Docker/Compose, git. Vì vậy phần "100%" phải dùng được cho cả repo 8 file. Thứ nào bắt repo nhỏ gánh chi phí của repo lớn thì không phải 100%.
2. **Đã có hai dòng docs tự hình thành.** Dòng *cdn / notification* gồm `SPECS / WORKFLOW / CONVENTIONS / ARCHITECTURE / features/vN`. Dòng *dashboard* gồm `AGENTS / decisions / specs có ID`, là dòng bộ skill này đang theo. Dòng cdn/notification có 4 thứ dòng dashboard còn thiếu:
   - quyền của AI theo trạng thái spec;
   - ngoại lệ hotfix;
   - bảng biến môi trường;
   - ma trận "đổi gì thì sửa file nào".
3. **Cùng một lỗi lặp ở ≥ 2 repo (§5).** Đó là bằng chứng mạnh nhất để đưa luật vào Core.

## 2. Tiêu chí "kế thừa 100%" và 4 tầng

Một thành phần vào **Core** khi đạt đủ cả 4 điều kiện:

1. Không phụ thuộc stack (Node, Python, .NET, shell đều dùng được).
2. Không phụ thuộc nghiệp vụ.
3. Không phụ thuộc quy mô (repo 8 file dùng được, không thấy thừa).
4. Có bằng chứng: lỗi xảy ra ở ≥ 2 dự án, hoặc có trong nguồn chuẩn ở principles §8.

| Tầng | Kế thừa | Dự án được làm gì | Ví dụ |
|---|---|---|---|
| **Core** | 100% nguyên văn | Chỉ ghi đè theo luật §7.3 | Thứ tự nguồn sự thật, hệ ID, quyền AI theo trạng thái |
| **Tham số** | 100% khung | Điền giá trị | Lệnh, lệnh chạy 1 test, nhánh tích hợp, ngôn ngữ docs |
| **Pack** | 100% *khi bật* | Chọn pack theo tín hiệu, điền tham số | HTTP API, token/khoá, job nền, migration, phát hành Docker |
| **Dự án** | 0% | Viết mới | REQ nghiệp vụ, thuật ngữ, quyết định, kiến trúc |

## 3. Tầng Core — kế thừa nguyên văn

Cột "WSFA" cho biết luật nằm ở đâu trong bộ skill. Mọi C-xx đều đã có từ `v1.0.0`.

| # | Thành phần | Nội dung bắt buộc | WSFA | Bằng chứng |
|---|---|---|---|---|
| C01 | Thứ tự nguồn sự thật | decisions > specs > AGENTS.md > code; skill ngoài thua docs dự án; mơ hồ thì dừng | Có — principles §1 | dashboard; notification claim "Single Source of Truth" ở 2 file (§5) |
| C02 | Ba cổng duyệt | Đề xuất → docs → thử docs → mới code | Có — SKILL.md | dashboard |
| C03 | **Quyền AI theo trạng thái spec** | Bảng trạng thái × được làm / không được làm. Không code khi spec `Draft`. Lệch spec thì đưa spec về trạng thái chưa duyệt | v1.0.0 — `templates/docs/specs/README.md` | notification `WORKFLOW.md` §1–2 |
| C04 | Hệ ID + truy vết | `SPEC-X`, `X-Rnn`, `X-ACnn`, `D-xx`, `P-xx`, `CHG-xx`; tên test chứa AC-ID; commit `[SPEC-X]`; không đánh số lại | Có — principles §3 | dashboard; cdn `EC-xx` không có ID xuyên suốt nên không truy được test |
| C05 | Trạng thái AC | `[ ]` / `[x]` (CI xanh trong chính PR) / `[~]` (lý do + cách đóng) | Có | dashboard |
| C06 | Mục bắt buộc của spec | Mục tiêu, trong/ngoài phạm vi (không rỗng), REQ EARS, NFR hoặc `N/A — lý do`, biên, AC, kiểm e2e, câu hỏi mở ("Không có") | Có — `templates/docs/specs/_template.md` | cdn, notification: spec không có câu hỏi mở |
| C07 | Quyết định append-only | Cột trạng thái, định danh hiện hành, P-xx | Có — `templates/docs/decisions.md` | dashboard |
| C08 | Thuật ngữ | Thuật ngữ / định nghĩa / không gọi là / tên trong code | Có | — |
| C09 | Đổi spec đã chạy | `CHG-xx` cho spec đã `Done`; phần lớn mới thì tạo spec con | Có — `skills/change-spec` | dashboard |
| C10 | **Ngoại lệ hotfix** | Hotfix được sửa code trước; spec phải cập nhật trong ≤ 1 ngày làm việc; nợ spec ghi vào `progress.md` tới khi đóng | v1.0.0 — `templates/docs/specs/README.md` | notification `WORKFLOW.md` §13 |
| C11 | **Ma trận loại thay đổi → file phải sửa** | Các dòng cố định: feature mới, đổi hành vi, contract công khai, schema, cấu hình/env, breaking, quyết định, khuôn mẫu code, **đổi stack** | v1.0.0 — `templates/docs/specs/README.md` | cdn `WORKFLOW` R8, notification §14 |
| C12 | Ranh giới 3 tầng — phần chung | 🚫 Không bao giờ: secret, `.env`, token, log credential, force push, `--no-verify`, tự merge. ⚠️ Hỏi trước: schema, contract, auth, mặc định bảo mật, thêm dependency, xoá dữ liệu/migration, sửa CI/CODEOWNERS/AGENTS. ✅ Luôn: viết test cùng code, chạy DoD trước khi báo xong | Có — `templates/AGENTS.md` | mọi repo |
| C13 | Khung DoD | Lệnh xanh + AC + cập nhật trạng thái docs | Có | — |
| C14 | Commit | `type(scope): mô tả [SPEC-X]` | Có | dashboard, notification, BotAutoTask đã theo; cdn, khaosat, citad chưa theo |
| C15 | **3 luật xử lý lỗi** | Không nuốt lỗi im lặng; message lỗi nội bộ không trả cho phía ngoài; việc best-effort được bỏ qua lỗi nhưng phải log kèm ngữ cảnh | v1.0.0 — `templates/AGENTS.md` | cdn `CONVENTIONS.md` §Error Handling — áp được cho mọi stack |
| C16 | **Secret & cấu hình** | `.env.example` (đúng tên này) đủ mọi khoá, không có giá trị thật; `.env` bị ignore; deny-rule chặn agent đọc `.env`; **file quyền cá nhân của agent không commit** | v1.0.0 — `templates/AGENTS.md`, `adapters/claude-settings.json`, `docs/reference/config.md` | khaosat commit `.claude/settings.json` chứa mật khẩu DB + đường dẫn máy; citad-res, deploy-tool dùng tên `.env-example` |
| C17 | Bộ nhớ phiên | `progress.md` ≤ 3 câu/dòng, ≤ ~5 KB; HANDOFF có ngày | Có | cdn `.devin/TASK.md` (gắn chặt một công cụ) |
| C18 | **Gotcha có ngày kiểm** | `triệu chứng → nguyên nhân → cách tránh · kiểm lần cuối YYYY-MM-DD`; sửa code đụng gotcha thì sửa gotcha trong cùng PR | v1.0.0 — `templates/project-skill` | cdn skill ghi "API key không có route tạo" trong khi code đã có |
| C19 | **AC cho lệnh vận hành** | Kiểm *tác dụng* (bảng tồn tại, file sinh ra), không chỉ exit code | v1.0.0 — `skills/write-spec` §5 | cdn `npm run migrate` không làm gì mà vẫn exit 0 |
| C20 | **Đổi stack = một change** | Đổi stack phải sửa cả lệnh trong AGENTS, CI, WORKFLOW/CONVENTIONS trong cùng PR; khảo sát kiểm "CI khớp manifest" | v1.0.0 — `templates/docs/specs/README.md`, `skills/survey-project` | notification: README ghi đã sang NestJS, CI vẫn build .NET, WORKFLOW còn trỏ `features/v1` + EF Core |
| C21 | Đặt file đúng chỗ công cụ đọc | Ma trận công cụ | Có — principles §5 | dashboard |
| C22 | Thử docs trước khi code | 2–3 task mẫu, phiên mới | Có — `skills/test-docs` | — |

## 4. Tầng Tham số — khung cố định, giá trị riêng

| Thành phần | Khung (kế thừa) | Dự án điền |
|---|---|---|
| Mục Lệnh trong AGENTS.md | install / dev / build / test / **test-one** / lint | Lệnh thật (bảng dưới) |
| Ngôn ngữ docs | ID, lệnh, tên file, mã lỗi giữ tiếng Anh | Văn bản: tiếng Việt / tiếng Anh (cdn bắt buộc tiếng Anh) |
| Git | Dạng commit C14 | Nhánh tích hợp, tiền tố nhánh, tag phát hành |
| Ma trận C11 | Các dòng loại thay đổi | Đường dẫn file thật |
| Tham chiếu cấu hình | Bảng `Biến / Bắt buộc / Mặc định / Mô tả / Nhạy cảm` | Giá trị (cdn `SPECS.md` là mẫu tốt) |
| Danh mục mã lỗi / trạng thái | Bảng `Mã / HTTP hoặc exit / Ý nghĩa / Khi nào` một chỗ | Các mã của dự án |
| Quy ước code | "Làm giống file X" + 1 snippet | File mẫu thật |
| Bản đồ repo | 1–2 cấp | Cây thật |

Lệnh chạy 1 test theo stack (điền thẳng vào AGENTS.md):

| Stack | Lệnh chạy 1 test |
|---|---|
| Node `node:test` | `node --test --test-name-pattern="<AC-ID>" <file>` |
| Vitest / Jest | `npx vitest run <file> -t "<AC-ID>"` / `npx jest <file> -t "<AC-ID>"` |
| Python pytest | `pytest <file> -k "<AC-ID>"` |
| .NET | `dotnet test --filter "FullyQualifiedName~<AC-ID>"` |
| Shell | `shellcheck <file>`; test bằng `bats <file>` nếu có |

## 5. Lỗi lặp lại giữa các dự án (bằng chứng cho Core)

Bảng lỗi đầy đủ (lỗi / gặp ở / cách tránh): [principles.md §7.1](principles.md). Ánh xạ sang ID:

- Docs lệch code → C04, C18, C20 · Hai "nguồn sự thật" → C01 · CI không chạy test / sai stack → C13, C20
- Commit sai quy ước → C14 · Allow-list agent bị commit, tên `.env-example` → C16 · File trạng thái gắn một công cụ → C17
- Gotcha cũ → C18 · `migrate` no-op exit 0 → C19 · Spec thiếu trạng thái/câu hỏi mở → C06 · Artifact build lệch nguồn → PK-RELEASE-R06

## 6. Tầng Pack — kế thừa có điều kiện

Mỗi pack là một thư viện REQ có ID ổn định `PK-<PACK>-Rnn`. Dự án bật pack khi thấy tín hiệu, rồi **chép REQ nguyên văn và điền tham số `{…}`**. Chỉ tạo pack khi có ≥ 2 dự án làm nguồn.

| Pack | Tín hiệu bật | Nguồn |
|---|---|---|
| PK-API — HTTP API | Có endpoint HTTP | cdn, notification, dashboard |
| PK-AUTH — token, khoá, chữ ký | Có xác thực, API key, webhook | cdn, notification, dashboard, BotAutoTask |
| PK-TENANT — cô lập dữ liệu | Có nhiều tenant/khách hàng/goal dùng chung | cdn, notification, BotAutoTask |
| PK-JOB — job nền, lịch, đồng bộ | Có worker, cron, queue, daemon | cdn, notification, crawler, BotAutoTask, deploy-tool |
| PK-DB — schema, migration | Có DB tự quản lý | cdn, notification, dashboard, khaosat, BotAutoTask |
| PK-RELEASE — Docker, registry, phát hành | Có image/binary phát hành | cdn, crawler, citad-res, dashboard, BotAutoTask |
| PK-AGENT — app điều khiển AI agent | App chạy lệnh do AI sinh ra | BotAutoTask — **ứng viên**, chờ dự án thứ 2 |

### File pack (GĐ2 — đã xong)

REQ chi tiết và AC mẫu nằm trong file riêng: [packs/PK-API.md](../packs/PK-API.md), [packs/PK-AUTH.md](../packs/PK-AUTH.md), [packs/PK-RELEASE.md](../packs/PK-RELEASE.md).

Định dạng file pack:
```
packs/<pack>.md
  Tín hiệu bật · Nguồn (dự án) · Tham số {…} kèm mặc định
  REQ (EARS) · AC mẫu Cho/Khi/Thì có tham số
  Dòng thêm vào AGENTS.md (Luôn / Hỏi trước / Không bao giờ)
  Mục khảo sát bổ sung cho survey-project · Gotchas có ngày kiểm
```

Pack đang có:
- PK-API, PK-AUTH, PK-RELEASE — đã viết, có ≥ 2 nguồn.
- PK-TENANT, PK-JOB, PK-DB — chờ tín hiệu (chưa đủ dự án thứ hai).
- PK-AGENT — chờ dự án thứ hai (hiện chỉ BotAutoTask).

## 7. Mô hình tuỳ biến

### 7.1 Cấu trúc trong WrittingSpecForAI

```
templates/      # = tầng Core + khung Tham số (giữ chỗ cũ, không đổi tên)
packs/          # MỚI — tầng Pack, mỗi pack một file
profiles.md     # MỚI — preset S / M / L
CHANGELOG.md    # MỚI — phiên bản base; ghi file Core / REQ pack nào đổi
```

### 7.2 Dự án khai báo dùng base (đầu AGENTS.md)

```md
> Base: writing-spec-for-ai v1.0 · Profile: M · Pack: PK-API, PK-AUTH, PK-RELEASE
> Ghi đè base: xem mục "Ghi đè" cuối file.
```

Spec dự án ghi REQ kế thừa bằng bảng thay vì chép lại lý do:

| REQ dự án | Kế thừa | Tham số / ghi đè |
|---|---|---|
| MEDIA-R07 | PK-AUTH-R01 | salt = `API_KEY_SALT` |
| MEDIA-R08 | PK-API-R05 | trần `limit` = 100 |

### 7.3 Luật ghi đè

| Hành động với luật Core/Pack | Điều kiện |
|---|---|
| **Siết** (thêm, chặt hơn) | Tự do, ghi ở AGENTS.md hoặc spec |
| **Nới** (bớt điều kiện) | Phải có `D-xx` ghi lý do |
| **Bỏ** | Phải có `D-xx` + ghi vào mục "Ghi đè" của AGENTS.md |

Thứ tự ưu tiên: `decisions dự án > spec dự án > AGENTS.md dự án (gồm Ghi đè) > Pack > Core > skill global`.

### 7.4 Profile — preset để repo nhỏ không gánh chi phí repo lớn

| Profile | Dấu hiệu | File tối thiểu | Ví dụ |
|---|---|---|---|
| **S** — script, hạ tầng | < ~30 file, không có API công khai | `AGENTS.md` (≤ 60 dòng) + README + `.env.example`; một file `docs/spec.md` nếu có hành vi cần nghiệm thu | vmu-deploy-tool, citad-postgresql, crawler |
| **M** — dịch vụ | Có API/worker/DB | Toàn bộ mức 0 + pack theo tín hiệu + CI chạy DoD | cdn, notification, khaosat, citad-res, BotAutoTask |
| **L** — nền tảng, monorepo | Nhiều package, có dự án phía dưới | M + mức 1–2: luật theo phạm vi, upgrade/compatibility, cưỡng chế bằng máy | dashboard |

Profile chỉ là điểm xuất phát. Tín hiệu mức 1–2 (principles §2) vẫn quyết định thêm gì.

> Chi tiết về profile S/M/L (dấu hiệu, file tối thiểu, ví dụ, khi nào nâng cấp) nằm trong file riêng: [profiles.md](../profiles.md).

### 7.5 Nâng cấp base

Tăng phiên bản base thì `CHANGELOG.md` liệt kê ID đổi (C-xx, PK-…-Rnn). Dự án grep ID trong docs của mình để biết chỗ phải xem lại. Chưa cần script (§9).

## 8. Lộ trình phát triển

| GĐ | Việc | Đầu ra | Trạng thái |
|---|---|---|---|
| 0 | Khảo sát + đề xuất | File này | ✅ Duyệt 2026-10-20 |
| 1 | Bổ sung Core còn thiếu | `git init` + tag `v1.0.0`, `CHANGELOG.md`; C03, C10, C11, C20 → `templates/docs/specs/README.md`; C15, C16 → `templates/AGENTS.md` + `adapters/claude-settings.json`; C18 → `templates/project-skill`; C19 → `skills/write-spec`; khảo sát C16/C19/C20 → `skills/survey-project`; mục kiểm → `review-checklist.md`; lỗi lặp → principles §7.1; template `docs/reference/config.md`, `error-codes.md`, `docs/changelog/` | ✅ `v1.0.0` |
| 2 | Pack + profile | `packs/PK-API.md`, `PK-AUTH.md`, `PK-RELEASE.md`; `profiles.md`; `propose-doc-design` hỏi profile + pack; `review-checklist.md` thêm mục kiểm REQ kế thừa; `base-kit.md` §6 trỏ sang file pack | ✅ `v1.1.0` |
| 3 | Thử trên BotAutoTask (M, brownfield) | Docs BotAutoTask theo base qua đủ 3 cổng | Chưa làm — xong khi `test-docs` không còn câu hỏi đã có đáp án trong docs |
| 4 | Công cụ nâng cấp (chỉ khi ≥ 2 dự án đã dùng) | Sub-skill `base-upgrade`; script kiểm REQ kế thừa trỏ tới ID còn tồn tại | Chờ tín hiệu |
| 5 | Pack theo nhu cầu | PK-TENANT, PK-JOB, PK-DB; PK-AGENT khi có dự án thứ 2 | Chờ tín hiệu |

> [!WARNING]
> Chỉ thử trên một repo M nên chưa kiểm được base có quá nặng với repo S hay không. Repo S đầu tiên dùng base phải ghi nhận lại số file docs và câu hỏi thừa.

## 9. Cố ý không làm

- **Không đóng gói npm/submodule:** team dùng nhiều stack (Node, Python, .NET, shell). Copy kèm phiên bản là đủ.
- **Không viết script đồng bộ trước GĐ4:** chưa có dự án thứ hai dùng base (YAGNI).
- **Không tạo pack nghiệp vụ** (thông báo, khảo sát, media): mỗi thứ chỉ có một dự án.
- **Không đổi tên hay chuyển `templates/`:** tránh gãy link trong skill và dự án đã chép.
- **Không bắt repo S tạo `specs/`, `decisions.md`, `glossary.md`:** chỉ thêm khi có tín hiệu.

## 10. Làm rõ

### Phiên 2026-10-20

- H: Mô hình trạng thái spec? → Đ: giữ `Draft → Ready → In progress → Done (+ As-built)`, thêm bảng quyền AI theo trạng thái (C03).
- H: Đặt pack ở đâu? → Đ: `packs/` trong WrittingSpecForAI, chung một phiên bản.
- H: Ngôn ngữ Core/Pack? → Đ: tiếng Việt; ID, lệnh, tên file, mã lỗi tiếng Anh; chỉ dịch khi có dự án English-only áp dụng.
- H: Quản lý phiên bản? → Đ: git + tag semver + `CHANGELOG.md` ghi ID luật đổi.
- H: GĐ1 gồm gì? → Đ: C03, C10, C11, C15, C16, C18, C19, C20 + template config / error-codes / changelog.
- H: Profile S/M/L và luật ghi đè (§7.3, §7.4)? → Đ: đồng ý như đề xuất.
- H: Pack viết trước? → Đ: PK-API, PK-AUTH, PK-RELEASE.
- H: Dự án thử? → Đ: BotAutoTask.

## 11. Câu hỏi mở

Không có.
