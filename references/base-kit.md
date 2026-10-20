# Base kit — phần kế thừa 100% và hướng phát triển base cho mọi dự án

> Trạng thái: **Đề xuất — chờ duyệt**. Ngày khảo sát: 2026-10-20.
> Nguồn: 9 repo thật (`D:\Workspace\VMU\*` + `D:\BotAutoTask`), đối chiếu với [principles.md](principles.md).
> File này chỉ ghi *cái gì kế thừa được và vì sao*. *Cách viết* vẫn nằm ở `principles.md`, `templates/`, `skills/`.

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
10. Câu hỏi mở

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

Cột "WSFA" cho biết bộ skill này đã có hay chưa: **Có** (đường dẫn) / **Một phần** / **Thiếu**.

| # | Thành phần | Nội dung bắt buộc | WSFA | Bằng chứng |
|---|---|---|---|---|
| C01 | Thứ tự nguồn sự thật | decisions > specs > AGENTS.md > code; skill ngoài thua docs dự án; mơ hồ thì dừng | Có — principles §1 | dashboard; notification claim "Single Source of Truth" ở 2 file (§5) |
| C02 | Ba cổng duyệt | Đề xuất → docs → thử docs → mới code | Có — SKILL.md | dashboard |
| C03 | **Quyền AI theo trạng thái spec** | Bảng trạng thái × được làm / không được làm. Không code khi spec `Draft`. Lệch spec thì đưa spec về trạng thái chưa duyệt | **Thiếu** | notification `WORKFLOW.md` §1–2 |
| C04 | Hệ ID + truy vết | `SPEC-X`, `X-Rnn`, `X-ACnn`, `D-xx`, `P-xx`, `CHG-xx`; tên test chứa AC-ID; commit `[SPEC-X]`; không đánh số lại | Có — principles §3 | dashboard; cdn `EC-xx` không có ID xuyên suốt nên không truy được test |
| C05 | Trạng thái AC | `[ ]` / `[x]` (CI xanh trong chính PR) / `[~]` (lý do + cách đóng) | Có | dashboard |
| C06 | Mục bắt buộc của spec | Mục tiêu, trong/ngoài phạm vi (không rỗng), REQ EARS, NFR hoặc `N/A — lý do`, biên, AC, kiểm e2e, câu hỏi mở ("Không có") | Có — `templates/docs/specs/_template.md` | cdn, notification: spec không có câu hỏi mở |
| C07 | Quyết định append-only | Cột trạng thái, định danh hiện hành, P-xx | Có — `templates/docs/decisions.md` | dashboard |
| C08 | Thuật ngữ | Thuật ngữ / định nghĩa / không gọi là / tên trong code | Có | — |
| C09 | Đổi spec đã chạy | `CHG-xx` cho spec đã `Done`; phần lớn mới thì tạo spec con | Có — `skills/change-spec` | dashboard |
| C10 | **Ngoại lệ hotfix** | Hotfix được sửa code trước; spec phải cập nhật trong ≤ 1 ngày làm việc; nợ spec ghi vào `progress.md` tới khi đóng | **Thiếu** | notification `WORKFLOW.md` §13 |
| C11 | **Ma trận loại thay đổi → file phải sửa** | Các dòng cố định: feature mới, đổi hành vi, contract công khai, schema, cấu hình/env, breaking, quyết định, khuôn mẫu code, **đổi stack** | Một phần (rải trong template PR) | cdn `WORKFLOW` R8, notification §14 |
| C12 | Ranh giới 3 tầng — phần chung | 🚫 Không bao giờ: secret, `.env`, token, log credential, force push, `--no-verify`, tự merge. ⚠️ Hỏi trước: schema, contract, auth, mặc định bảo mật, thêm dependency, xoá dữ liệu/migration, sửa CI/CODEOWNERS/AGENTS. ✅ Luôn: viết test cùng code, chạy DoD trước khi báo xong | Có — `templates/AGENTS.md` | mọi repo |
| C13 | Khung DoD | Lệnh xanh + AC + cập nhật trạng thái docs | Có | — |
| C14 | Commit | `type(scope): mô tả [SPEC-X]` | Có | dashboard, notification, BotAutoTask đã theo; cdn, khaosat, citad chưa theo |
| C15 | **3 luật xử lý lỗi** | Không nuốt lỗi im lặng; message lỗi nội bộ không trả cho phía ngoài; việc best-effort được bỏ qua lỗi nhưng phải log kèm ngữ cảnh | **Thiếu** | cdn `CONVENTIONS.md` §Error Handling — áp được cho mọi stack |
| C16 | **Secret & cấu hình** | `.env.example` (đúng tên này) đủ mọi khoá, không có giá trị thật; `.env` bị ignore; deny-rule chặn agent đọc `.env`; **file quyền cá nhân của agent không commit** | Một phần (deny-rule có, phần còn lại thiếu) | khaosat commit `.claude/settings.json` chứa mật khẩu DB + đường dẫn máy; citad-res, deploy-tool dùng tên `.env-example` |
| C17 | Bộ nhớ phiên | `progress.md` ≤ 3 câu/dòng, ≤ ~5 KB; HANDOFF có ngày | Có | cdn `.devin/TASK.md` (gắn chặt một công cụ) |
| C18 | **Gotcha có ngày kiểm** | `triệu chứng → nguyên nhân → cách tránh · kiểm lần cuối YYYY-MM-DD`; sửa code đụng gotcha thì sửa gotcha trong cùng PR | Một phần (thiếu ngày) | cdn skill ghi "API key không có route tạo" trong khi code đã có |
| C19 | **AC cho lệnh vận hành** | Kiểm *tác dụng* (bảng tồn tại, file sinh ra), không chỉ exit code | **Thiếu** | cdn `npm run migrate` không làm gì mà vẫn exit 0 |
| C20 | **Đổi stack = một change** | Đổi stack phải sửa cả lệnh trong AGENTS, CI, WORKFLOW/CONVENTIONS trong cùng PR; khảo sát kiểm "CI khớp manifest" | **Thiếu** | notification: README ghi đã sang NestJS, CI vẫn build .NET, WORKFLOW còn trỏ `features/v1` + EF Core |
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

| Lỗi | Gặp ở | Luật Core |
|---|---|---|
| Docs mô tả khác code (format/độ dài API key, thuật toán hash, cây thư mục) | cdn ×3, BotAutoTask (đường dẫn file không tồn tại trong design spec), notification | C04, C18, C20 + spec `As-built` phải kèm test chứng minh |
| Hai file cùng nhận là "nguồn sự thật" | notification (`SPECS.md` + `knowledge.md`), cdn (`SPECS.md` + `ARCHITECTURE.md`) | C01: một sự thật một chỗ; khảo sát grep "Single Source of Truth" |
| CI không chạy test, hoặc CI chạy sai stack | cdn, BotAutoTask (chỉ build), citad-*, notification (sai stack) | C13 + C20; profile M/L bắt buộc CI chạy DoD |
| Commit không theo quy ước | cdn, khaosat, citad-* | C14; vi phạm ≥ 2 lần thì thêm commitlint (principles §2 mức 2) |
| Secret / thông tin máy bị commit qua file cấu hình agent | khaosat | C16 |
| Tên file env mẫu không thống nhất | citad-vmu-resources, vmu-deploy-tool | C16 |
| File trạng thái gắn chặt một công cụ | cdn `.devin/TASK.md` | C17: `docs/progress.md` không phụ thuộc công cụ |
| Gotcha cũ vẫn được tin | cdn | C18 |
| Lệnh vận hành không làm gì mà vẫn exit 0 | cdn | C19 |
| Spec không có trạng thái / câu hỏi mở | cdn, notification (một phần), dashboard (18/19 spec) | C06 |
| File build được commit nhưng lệch với `src/` | BotAutoTask `dist/` | Pack PK-RELEASE R06 |

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

### REQ lõi đề xuất (rút gọn; chuyển sang file pack ở GĐ2)

**PK-API**
- R01 — Mọi lỗi MUST trả cùng một định dạng `{error, code, statusCode, details?}`; `code` nằm trong danh mục mã lỗi.
- R02 — Nếu lỗi là 5xx, hệ thống MUST NOT trả message/stack cho client, trừ khi bật `{cờ debug}` ngoài production.
- R03 — Input sai MUST trả 400, `details` liệt kê theo từng trường.
- R04 — `GET /health` MUST trả 200, không cần auth, không lộ thông tin nội bộ.
- R05 — Danh sách MUST phân trang `{items, total, page, limit}`; `limit` ≤ `{trần}`.
- R06 — Trong production, CORS MUST dùng danh sách origin cụ thể, không dùng `*`.
- R07 — Khi có contract máy đọc (OpenAPI), file đó là nguồn thật; spec chỉ link tới.

**PK-AUTH**
- R01 — Secret/khoá MUST lưu dạng hash có salt; giá trị gốc chỉ trả về đúng một lần khi tạo.
- R02 — So sánh secret MUST dùng phép so sánh constant-time.
- R03 — Mỗi loại token MUST mang claim loại (`typ`); endpoint MUST từ chối token sai loại (cdn `aca4c78`).
- R04 — Refresh token MUST duy nhất cho mỗi lần cấp, quay vòng sau mỗi lần dùng, thu hồi được (cdn `706d120`).
- R05 — URL/webhook có ký MUST dùng HMAC kèm `exp`; quá hạn thì bị từ chối.
- R06 — Nếu thiếu hoặc hỏng cấu hình auth, hệ thống MUST từ chối (fail-closed) (BotAutoTask Worker).
- R07 — Hệ thống MUST NOT log token, mật khẩu, header `Authorization`.

**PK-TENANT**
- R01 — Mọi truy vấn dữ liệu của tenant MUST lọc theo `tenant_id` lấy từ danh tính đã xác thực, không lấy từ input.
- R02 — Thao tác hàng loạt (pause, xoá, đồng bộ) MUST chỉ tác động trong phạm vi được chỉ định (bug `/pause` của BotAutoTask).
- R03 — Bộ test MUST có ca cô lập dùng 2 tenant (cdn skill).

**PK-JOB**
- R01 — Job MUST idempotent: chạy lại cùng input không sinh bản ghi trùng (cdn sync EC-02, BotAutoTask nonce).
- R02 — Mốc tiến độ (`last_sync_at`, checkpoint) MUST chỉ ghi sau khi đơn vị việc thành công.
- R03 — Một đơn vị lỗi MUST NOT chặn đơn vị khác; kết thúc có lỗi thì exit code ≠ 0.
- R04 — Khi nhận tín hiệu dừng, job MUST làm xong việc đang dở hoặc trả việc lại hàng đợi.
- R05 — Logic chạy định kỳ MUST có lệnh chạy thủ công tương đương.
- R06 — Lịch chạy MUST ghi rõ múi giờ (commit crawler "chỉnh TZ về VN").

**PK-DB**
- R01 — Mọi thay đổi schema MUST có migration đánh số, có đường lui.
- R02 — Migration đã phát hành MUST NOT bị sửa; muốn sửa thì tạo migration mới.
- R03 — Lệnh migrate MUST thất bại khi không áp được migration (C19).
- R04 — Snapshot schema (`schema.sql`, `schema.prisma`) MUST khớp tổng các migration; CI kiểm.

**PK-RELEASE**
- R01 — `.env.example` MUST đủ mọi biến; ứng dụng MUST validate env lúc khởi động và báo gộp mọi lỗi (cdn `config`).
- R02 — Image/binary MUST build từ tag `{release/v<semver>}`; tag image = phiên bản.
- R03 — Container MUST chạy bằng user non-root, build multi-stage.
- R04 — Mỗi phiên bản MUST có changelog; breaking change MUST có hướng dẫn nâng cấp (`templates/docs/upgrade`).
- R05 — PR vào nhánh môi trường MUST ghi kế hoạch rollback (= triển khai lại tag trước).
- R06 — Nếu artifact build được commit vào repo, CI MUST kiểm artifact khớp nguồn.

### Định dạng một file pack (GĐ2)

```
packs/<pack>.md
  Tín hiệu bật · Nguồn (dự án) · Tham số {…} kèm mặc định
  REQ (EARS) · AC mẫu Cho/Khi/Thì có tham số
  Dòng thêm vào AGENTS.md (Luôn / Hỏi trước / Không bao giờ)
  Mục khảo sát bổ sung cho survey-project · Gotchas có ngày kiểm
```

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

### 7.5 Nâng cấp base

Tăng phiên bản base thì `CHANGELOG.md` liệt kê ID đổi (C-xx, PK-…-Rnn). Dự án grep ID trong docs của mình để biết chỗ phải xem lại. Chưa cần script (§9).

## 8. Lộ trình phát triển

| GĐ | Việc | Đầu ra | Xong khi |
|---|---|---|---|
| 0 | Khảo sát + đề xuất | File này | Người dùng duyệt |
| 1 | Bổ sung phần Core còn thiếu | `git init` WSFA + tag `v1.0.0`; C03, C10, C11 vào `templates/docs/specs/README.md` (hoặc WORKFLOW mới); C15, C16 vào `templates/AGENTS.md`; C18 vào `templates/project-skill`; C19, C20 vào `skills/survey-project` + `review-checklist`; bảng §5 nhập vào principles §7; thêm template `docs/reference/config.md`, `docs/reference/error-codes.md`, `docs/changelog/` | review-checklist có mục cho từng C-xx mới |
| 2 | Pack + profile | `packs/` (PK-API, PK-AUTH, PK-RELEASE trước — nhiều nguồn nhất), `profiles.md`, `CHANGELOG.md`; `propose-doc-design` hỏi profile + pack | Mỗi pack có ≥ 2 nguồn và AC mẫu |
| 3 | Thử trên 2 dự án | BotAutoTask (M, brownfield) + vmu-deploy-tool (S) qua đủ 3 cổng | `test-docs` không còn câu hỏi đã có đáp án trong docs; repo S có ≤ 3 file docs |
| 4 | Công cụ nâng cấp (chỉ khi ≥ 2 dự án đã dùng) | Sub-skill `base-upgrade`; script kiểm REQ kế thừa trỏ tới ID còn tồn tại | Nâng 1 dự án từ v1.0 lên v1.1 không sót |
| 5 | Pack theo nhu cầu | PK-TENANT, PK-JOB, PK-DB; PK-AGENT khi có dự án thứ 2 | Theo tín hiệu |

## 9. Cố ý không làm

- **Không đóng gói npm/submodule:** team dùng nhiều stack (Node, Python, .NET, shell). Copy kèm phiên bản là đủ.
- **Không viết script đồng bộ trước GĐ4:** chưa có dự án thứ hai dùng base (YAGNI).
- **Không tạo pack nghiệp vụ** (thông báo, khảo sát, media): mỗi thứ chỉ có một dự án.
- **Không đổi tên hay chuyển `templates/`:** tránh gãy link trong skill và dự án đã chép.
- **Không bắt repo S tạo `specs/`, `decisions.md`, `glossary.md`:** chỉ thêm khi có tín hiệu.

## 10. Câu hỏi mở

1. **[CẦN LÀM RÕ] Trạng thái spec** — WSFA dùng `Draft → Ready → In progress → Done (+ As-built)`, notification dùng 7 trạng thái. Đề xuất: giữ 4 trạng thái của WSFA, thêm cột "AI được làm / không được làm" (C03). Hệ quả nếu dùng 7 trạng thái: AI được kiểm soát chi tiết hơn, nhưng repo S quá nặng.
2. **[CẦN LÀM RÕ] Vị trí pack** — Đề xuất: đặt `packs/` trong WSFA. Hệ quả nếu tách repo riêng: phải ghép phiên bản hai nơi.
3. **[CẦN LÀM RÕ] Ngôn ngữ của Core** — Đề xuất: viết tiếng Việt, ID tiếng Anh; chỉ dịch khi có dự án bắt buộc tiếng Anh (cdn) áp dụng. Hệ quả nếu song ngữ ngay: gấp đôi chi phí bảo trì.
4. **[CẦN LÀM RÕ] Phiên bản base** — WSFA hiện **chưa phải git repo**, nên chưa ghim được phiên bản. Đề xuất: `git init` + tag `v1.0.0` ở GĐ1.
5. **[CẦN LÀM RÕ] Dự án thử** — Đề xuất: BotAutoTask (M) + vmu-deploy-tool (S). Hệ quả nếu chỉ thử repo M: không kiểm được base có quá nặng với repo nhỏ không.
