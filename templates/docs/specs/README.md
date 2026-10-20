# Đặc tả <tên dự án>

Nguồn sự thật về yêu cầu. Quyết định ở `../decisions.md`, thuật ngữ ở `../glossary.md`, tiến độ ở `../progress.md` (không ghi nhật ký ở file này).

## Quy ước

- ID spec `SPEC-<KHU-VỰC>`; yêu cầu `<KHU-VỰC>-R<số>`; nghiệm thu `<KHU-VỰC>-AC<số>`. Không đánh số lại; bỏ thì ghi deprecated.
- Mức: **MUST**, **SHOULD** (lệch phải ghi lý do), **MAY**. Giai đoạn ghi kèm: `MUST (GĐ2)`.
- AC *Cho / Khi / Thì*, tên test chứa AC-ID. `[x]` trong chính PR có CI xanh; `[~]` cần môi trường thật, kèm lý do + cách đóng.
- Trạng thái: `Draft` → `Ready` (người dùng duyệt, không còn `[CẦN LÀM RÕ]`) → `In progress` → `Done` (mọi AC `[x]` hoặc `[~]`, chuyển trong PR cuối). Code có sẵn chưa spec: `As-built`.
- Spec `Ready`/`Done` cần đổi: qua `../changes/`. Phần lớn mới: spec con.
- Spec mới dùng `_template.md`; thiết kế dùng `_design-template.md`.

## Danh mục

| ID | File | Nội dung | Giai đoạn | Trạng thái |
|---|---|---|---|---|
| SPEC-ARCH | [00-architecture.md](00-architecture.md) | Kiến trúc, nguyên tắc | 1 | Draft |

## Đối chiếu tài liệu nguồn <!-- khi spec dựng từ PRD/docx -->

| Mục nguồn | Spec / REQ |
|---|---|

**Phần lệch so với nguồn:** <nội dung chốt sau tài liệu nguồn, chỉ có ở spec + decisions>

## Thứ tự triển khai đề xuất

1.
