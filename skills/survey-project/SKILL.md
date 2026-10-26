---
name: survey-project
description: Dùng ở Bước 1–2 khi bắt đầu dự án mới, khi repo chưa có hoặc có tài liệu AI rời rạc, hoặc khi người dùng nói "khảo sát dự án", "audit docs", "chuẩn bị viết spec". Thu thập bằng chứng hiện trạng repo (stack, lệnh, CI, vùng rủi ro, số đo sàn chất lượng) và đề xuất Profile S/M/L cùng các Domain Pack (PK-*).
---

# Survey project — khảo sát dự án (Bước 1–2 của writing-spec-for-ai)

Đầu vào: repo dự án (và tài liệu nguồn bên ngoài nếu có: PRD, docx, ticket).
Đầu ra: bảng hiện trạng **mỗi dòng có đường dẫn bằng chứng** + kết luận greenfield/brownfield + Profile (`S/M/L`), mức (`0/1/2` — Mức 0 bắt buộc, Mức 1–2 thêm khi có tín hiệu; xem [glossary](../../references/glossary.md)) và danh sách Pack (`PK-*`) đề xuất. Kết quả này điền thẳng vào mục 1–2 của `propose-doc-design`.

Chỉ đọc, không sửa file nào của dự án. Repo lớn (`> 50` file hoặc không đọc hết trong ~10 phút) → uỷ quyền cho subagent chỉ đọc [`spec-surveyor`](../../agents/spec-surveyor.md), chỉ nhận lại bảng kết luận kèm đường dẫn `path:line` để giữ sạch context của phiên chính.

## 1. Thu thập — mỗi mục phải có bằng chứng đường dẫn

| Hạng mục | Cách kiểm | Bằng chứng cần ghi |
|---|---|---|
| **Knowledge Graph sẵn có** *(nếu có)* | Kiểm tra `.ua/knowledge-graph.json`, `.understand-anything/knowledge-graph.json`, hoặc `graphify-out/` | Lấy nhanh danh sách layer kiến trúc, entry point, import map và module trung tâm (god nodes) mà không cần đọc lại toàn bộ mã nguồn |
| Stack + major version | Đọc `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` / `*.csproj`, `.nvmrc`, lockfile | "NestJS 12, Prisma 7, PostgreSQL 15" — kèm đường dẫn file |
| Lệnh dev/build/test/lint | Đọc `scripts` trong manifest, CI workflow, Makefile, README | Lệnh thật + **lệnh chạy đúng 1 test** (tự tìm; không có thì ghi "chưa có" — đây là lỗ hổng mức 0) |
| Tài liệu AI sẵn có | `ls` các vị trí ma trận (principles §5): `AGENTS.md`, `CLAUDE.md`, `CONSTRAINTS.md`, `.github/copilot-instructions.md`, `.cursor/rules/`, `.agents/` | File nào có, đặt đúng chỗ công cụ đọc hay không, nội dung mâu thuẫn/trùng nhau ở đâu |
| File mồ côi / bị bỏ quên | `git check-ignore <file>` với mọi file docs; grep xem file có được file nào link tới không; so ngày sửa với `git log -5` | Danh sách file bị ignore hoặc không được trỏ tới |
| Tài liệu nguồn bên ngoài | Hỏi người dùng / tìm `*.docx`, `docs/prd`, ticket | Đường dẫn, phiên bản, ngày |
| Cưỡng chế & **Sàn chất lượng** (**Không hạ chuẩn âm thầm**, `C23`) | Đọc CI, `eslint`/`biome`/`ruff` config, hooks (husky/pre-commit), đếm nhanh các cờ `@ts-ignore`/`eslint-disable`/`.skip` và coverage hiện tại | Cái gì đã có máy chặn, số đo baseline hôm nay để đưa vào `CONSTRAINTS.md` |
| **CI khớp stack** (**Đổi stack là một thay đổi**, `C20`) | So lệnh/đường dẫn trong CI với manifest và file có thật (`git ls-files`) | CI build file không tồn tại, chạy stack cũ, hoặc không chạy test (chỉ build) |
| **Nhiều "nguồn sự thật"** (**Thứ tự nguồn sự thật**, `C01`) | grep `Single Source of Truth`, `nguồn sự thật`, `SSOT` trong docs; so cùng một sự thật (format key, env, cây thư mục) giữa các file | Các cặp file tranh nhau hoặc mô tả khác nhau |
| **Secret & cấu hình** (`C16`) | Tên file env mẫu (`.env.example`?); `.env` có bị ignore không; `git ls-files .claude .cursor .vscode .zcode` | File quyền cá nhân của agent bị commit (allow-list, đường dẫn máy, mật khẩu) |
| **Lệnh vận hành** (**Kiểm tác dụng lệnh vận hành**, `C19`) | Chạy thử an toàn (`migrate`, `sync`, `seed`) trên môi trường local hoặc đọc code của lệnh | Lệnh không làm gì mà vẫn exit 0 |
| Quy ước git thực tế | `git log --oneline -30` | Dạng commit thật, tên nhánh thật (khớp hay lệch quy định viết) |
| Vùng rủi ro & **Tín hiệu bật Pack** | Quét theo 8 pack trong [`packs/`](../../packs/): HTTP API (`PK-API`), Auth/Token/Webhook (`PK-AUTH`), Docker/Release (`PK-RELEASE`), DB/Migration (`PK-DB`), Logging/Metrics (`PK-OBS`), Frontend UI/E2E (`PK-FE`), Worker/Cron/Queue (`PK-JOB`), AI Agent/MCP (`PK-AGENT`) | Danh sách thư mục/file rủi ro + Pack nào có tín hiệu bật kèm câu hỏi khảo sát bổ sung ở cuối mỗi file `packs/PK-*.md` |
| Hạ tầng bên ngoài | CI config (runner, hạn mức), registry, secrets dùng trong workflow, team/org GitHub | Điều kiện có thể chặn AC: gói Free, hết hạn mức, team chưa tồn tại |
| Brownfield? | Có code chạy + có test + không có spec? | "Brownfield — cần spec As-built (mô tả code đã có)" hoặc "Greenfield" |

## 2. Chấm Profile, Mức đề xuất & Pack (theo `profiles.md` & `base-kit.md`)

- **Profile (`S` / `M` / `L`):** đối chiếu với [`profiles.md`](../../profiles.md): S < ~30 file, M ~30–200, L > 200; số file chỉ là gợi ý, tín hiệu (số người, CI, vùng rủi ro, số spec) quyết định cuối cùng.
- **Mức 0 (0.1–0.16):** luôn đủ toàn bộ sau khảo sát.
- **Mức 1–2:** liệt kê từng thành phần kèm **tín hiệu thấy được trong repo** (vd. `CONSTRAINTS.md`, `DESIGN-xx`, `adr/`, `upgrade/`, skill `verify-<app>`).
- **Pack miền (`PK-*`):** chỉ bật pack có tín hiệu thật trong repo; đọc mục *"Mục khảo sát bổ sung"* của từng pack được bật để thu thập đủ tham số `{…}`.

## 3. Bẫy thường gặp

- Chỉ đọc README rồi khẳng định lệnh chạy được — phải đối chiếu manifest/CI.
- Quên hạ tầng bên ngoài → AC treo lơ lửng lúc triển khai.
- Kết luận "thiếu docs" trong khi file docs bị `.gitignore`.
- Không phân biệt "chưa có spec" (greenfield) với "có code chưa có spec" (brownfield → As-built, mỗi REQ cần bằng chứng).
- Dự án vừa đổi stack: README đã mới nhưng CI, WORKFLOW, CONVENTIONS còn stack cũ.

## Kiểm tra trước khi xong

- [ ] Mọi dòng kết luận có đường dẫn bằng chứng.
- [ ] Có kèm lệnh chạy 1 test (hoặc ghi rõ "chưa có").
- [ ] Có kết luận greenfield/brownfield, Profile (`S/M/L`), và danh sách Pack (`PK-*`) kèm tín hiệu.
- [ ] Mỗi thành phần mức 1–2 có tín hiệu; repo mới ghi "chưa có tín hiệu".
