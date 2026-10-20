# Đề xuất thiết kế docs cho AI — <tên dự án>

> Trạng thái: **Chờ review (Cổng 1)**. Chưa tạo file nào trong repo.

## 1. Hiện trạng

| Hạng mục | Phát hiện | Bằng chứng |
|---|---|---|
| Stack (major version) | | `package.json` |
| Lệnh build/test/lint/dev, chạy 1 test | | |
| Greenfield / brownfield | | |
| Tài liệu sẵn có + vị trí đúng/sai công cụ đọc | | |
| File mồ côi / bị ignore / cũ / mâu thuẫn | | |
| Tài liệu nguồn bên ngoài (PRD, docx) | | |
| Cưỡng chế sẵn có (lint, hook, CI, CODEOWNERS) | | |
| Quy ước git thực tế | | `git log` |
| Vùng rủi ro | | |
| Điều kiện hạ tầng bên ngoài có thể chặn AC | | |
| Công cụ AI team dùng | | |

## 2. Mức đề xuất

- Base: writing-spec-for-ai <phiên bản> · Profile: <S | M | L> — xem `profiles.md` về dấu hiệu và file tối thiểu.
- Pack: <PK-… — tín hiệu: …> — xem `packs/PK-….md` về tín hiệu bật và REQ.
- Mức 0: toàn bộ (0.1–0.16).
- Mức 1: <thành phần> — tín hiệu: <…>
- Mức 2: <thành phần> — tín hiệu: <…>

## 3. Cây file đề xuất

```
AGENTS.md
CLAUDE.md                         # adapter
.github/copilot-instructions.md   # adapter (nếu dùng Copilot)
docs/glossary.md
docs/decisions.md
docs/specs/README.md
docs/specs/_template.md
docs/specs/00-<khu-vực>.md        # Draft / As-built
docs/progress.md
docs/plans/                       # mức 1
docs/changes/                     # mức 1, brownfield
.agents/skills/<tên>/SKILL.md     # mức 2
```

| File | Mục đích | Nội dung chính | Tạo / sửa / di chuyển / xoá |
|---|---|---|---|

## 4. Nội dung dự kiến của AGENTS.md

- **Lệnh:**
- ✅ **Luôn:**
- ⚠️ **Hỏi trước:**
- 🚫 **Không bao giờ:**
- **DoD:**
- **File mẫu để bắt chước:**
- **Luật chuyển xuống phạm vi:** <thư mục → luật>

## 5. Spec dự kiến

| ID | Khu vực | Trạng thái dự kiến | Nguồn yêu cầu |
|---|---|---|---|

## 6. Thuật ngữ cần chốt

## 7. Cưỡng chế, hook, skill dự án

| Thành phần | Luật/quy trình | Tín hiệu |
|---|---|---|

## 8. Kế hoạch thử tài liệu (Bước 7)

| Task mẫu | Kiểm điều gì |
|---|---|

## 9. Cố ý không làm

## 10. Câu hỏi cho người dùng

<!-- Mỗi câu kèm phương án đề xuất và hệ quả. Câu ảnh hưởng lớn nhất trước. -->

1. **[CẦN LÀM RÕ]** … — Đề xuất: … — Hệ quả nếu khác: …
