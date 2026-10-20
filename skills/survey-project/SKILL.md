---
name: survey-project
description: Khảo sát một dự án để chuẩn bị viết bộ spec và tài liệu cho AI agent — thu thập stack, lệnh, tài liệu sẵn có, vùng rủi ro, điều kiện hạ tầng có thể chặn nghiệm thu; chấm greenfield/brownfield và đề xuất mức 0/1/2 kèm tín hiệu. Dùng khi bắt đầu dự án mới, khi repo chưa có hoặc có tài liệu AI rời rạc, hoặc khi người dùng nói "khảo sát dự án", "audit docs", "chuẩn bị viết spec".
---

# Survey project — khảo sát dự án (Bước 1–2 của writing-spec-for-ai)

Đầu vào: repo dự án (và tài liệu nguồn bên ngoài nếu có: PRD, docx, ticket).
Đầu ra: bảng hiện trạng **mỗi dòng có đường dẫn bằng chứng** + kết luận greenfield/brownfield + mức đề xuất. Kết quả này điền thẳng vào mục 1–2 của `propose-doc-design`.

Chỉ đọc, không sửa file nào của dự án. Repo lớn (không đọc hết trong ~10 phút) → dùng subagent khảo sát, chỉ nhận lại bảng kết luận kèm đường dẫn.

## 1. Thu thập — mỗi mục phải có bằng chứng đường dẫn

| Hạng mục | Cách kiểm | Bằng chứng cần ghi |
|---|---|---|
| Stack + major version | Đọc `package.json` / `pyproject.toml` / `go.mod` / `pom.xml`, `.nvmrc`, lockfile | "NestJS 12, Prisma 7, PostgreSQL 15" — kèm đường dẫn file |
| Lệnh dev/build/test/lint | Đọc `scripts` trong manifest, CI workflow, Makefile, README | Lệnh thật + **lệnh chạy đúng 1 test** (tự tìm; không có thì ghi "chưa có" — đây là lỗ hổng mức 0) |
| Tài liệu AI sẵn có | `ls` các vị trí ma trận (principles §5): `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/`, `.agents/` | File nào có, đặt đúng chỗ công cụ đọc hay không, nội dung mâu thuẫn/trùng nhau ở đâu |
| File mồ côi / bị bỏ quên | `git check-ignore <file>` với mọi file docs; grep xem file có được file nào link tới không; so ngày sửa với `git log -5` | Danh sách file bị ignore hoặc không được trỏ tới |
| Tài liệu nguồn bên ngoài | Hỏi người dùng / tìm `*.docx`, `docs/prd`, ticket | Đường dẫn, phiên bản, ngày |
| Cưỡng chế sẵn có | Đọc CI, `eslint` config, hooks (husky/pre-commit), branch protection, CODEOWNERS | Cái gì đã có máy chặn, cái gì chỉ nằm trong văn xuôi |
| Quy ước git thực tế | `git log --oneline -30` | Dạng commit thật, tên nhánh thật (khớp hay lệch quy định viết) |
| Vùng rủi ro | grep: auth/login/token, permission/role, schema/migration, payment/billing, personal data/email/phone | Danh sách thư mục/file rủi ro → sau này quyết định luật "Hỏi trước" |
| Hạ tầng bên ngoài | CI config (runner, hạn mức), registry, secrets dùng trong workflow, team/org GitHub | Điều kiện có thể chặn AC: gói Free, hết hạn mức, team chưa tồn tại |
| Brownfield? | Có code chạy + có test + không có spec? | "Brownfield — cần spec As-built" hoặc "Greenfield" |

## 2. Chấm mức đề xuất (theo principles §2)

- Mức 0 (0.1–0.14): luôn đủ toàn bộ sau khảo sát.
- Mức 1: liệt kê từng thành phần kèm **tín hiệu thấy được trong repo** — ví dụ "> 3 spec" phải đếm được, "chạm schema" phải chỉ được file migration.
- Mức 2: chỉ khi đã thấy luật bị vi phạm ≥ 2 lần hoặc quy trình lặp ≥ 2 lần trong lịch sử git/issue. Repo mới → ghi "chưa có tín hiệu, bổ sung sau".

## 3. Bẫy thường gặp

- Chỉ đọc README rồi khẳng định lệnh chạy được — README cũ là luật thường xuyên; phải đối chiếu manifest/CI.
- Quên hạ tầng bên ngoài → AC treo lơ lửng lúc triển khai (bài học dashboard: gói GitHub Free chặn AC phát hành).
- Kết luận "thiếu docs" trong khi file docs bị `.gitignore` — docs tồn tại nhưng không ai thấy.
- Không phân biệt "chưa có spec" (greenfield) với "có code chưa có spec" (brownfield → As-built, mỗi REQ cần bằng chứng).

## Kiểm tra trước khi xong

- [ ] Mọi dòng kết luận có đường dẫn bằng chứng.
- [ ] Có kèm lệnh chạy 1 test (hoặc ghi rõ "chưa có").
- [ ] Có kết luận greenfield/brownfield.
- [ ] Mỗi thành phần mức 1–2 có tín hiệu; repo mới ghi "chưa có tín hiệu".
