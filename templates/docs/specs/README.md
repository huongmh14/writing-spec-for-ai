# Đặc tả <tên dự án>

Nguồn sự thật về yêu cầu. Quyết định ở `../decisions.md`, thuật ngữ ở `../glossary.md`, tiến độ ở `../progress.md` (không ghi nhật ký ở file này).

## Quy ước

- ID spec `SPEC-<KHU-VỰC>`; yêu cầu `<KHU-VỰC>-R<số>`; nghiệm thu `<KHU-VỰC>-AC<số>`. Không đánh số lại; bỏ thì ghi deprecated.
- Mức: **MUST**, **SHOULD** (lệch phải ghi lý do), **MAY**. Giai đoạn ghi kèm: `MUST (GĐ2)`.
- AC *Cho / Khi / Thì*, tên test chứa AC-ID. `[x]` trong chính PR có CI xanh; `[~]` cần môi trường thật, kèm lý do + cách đóng.
- Trạng thái: `Draft` → `Ready` (người dùng duyệt, không còn `[CẦN LÀM RÕ]`) → `In progress` → `Done` (mọi AC `[x]` hoặc `[~]`, chuyển trong PR cuối). Code có sẵn chưa spec: `As-built`.
- Spec `Ready`/`Done` cần đổi: qua `../changes/`. Phần lớn mới: spec con.
- Spec mới dùng `_template.md`; thiết kế dùng `_design-template.md`.

## Quyền của AI theo trạng thái spec

| Trạng thái | AI được làm | AI không được làm |
|---|---|---|
| `Draft` | Đọc, chỉ chỗ thiếu/mâu thuẫn/mơ hồ, đề xuất phương án kèm đánh đổi, viết AC | **Viết code triển khai**; tự chọn phương án thay người dùng |
| `Ready` | Lập plan, chia PR, chuẩn bị migration, viết test theo AC | Đổi nội dung spec trong lúc làm |
| `In progress` | Viết code + test, đánh `[x]` AC khi CI xanh, báo blocker | Lệch khỏi spec mà không nói; thêm chức năng "nhân tiện" |
| `Done` | Sửa lỗi đã xác nhận, đúng hành vi spec mô tả | Đổi hành vi khi chưa có `../changes/CHG-xx` được duyệt |
| `As-built` | Ghi bằng chứng, nêu hành vi đáng ngờ vào câu hỏi mở | Coi code hiện có là chuẩn; "sửa cho hợp lý" |

- Được yêu cầu code cho spec `Draft`: trả lời spec chưa duyệt, hỏi có chuyển `Ready` không.
- Code không theo được spec: dừng, nêu chỗ lệch, đề xuất sửa spec trước.
- **Hotfix** là ngoại lệ duy nhất được sửa code trước spec: spec phải cập nhật trong ≤ 1 ngày làm việc; tới lúc đó ghi nợ vào `../progress.md` (`Còn dở: nợ spec <SPEC-X>`).

## Tài liệu phải sửa theo loại thay đổi

Sửa trong **cùng PR** với code.

| Loại thay đổi | File phải sửa |
|---|---|
| Feature mới | spec mới + dòng trong bảng Danh mục |
| Đổi hành vi spec `Ready`/`Done` | `../changes/CHG-xx` → spec |
| Contract công khai (API, mã lỗi, payload, CLI) | spec + contract máy đọc + `../reference/error-codes.md` nếu đổi mã |
| Schema dữ liệu | spec + migration + `../upgrade/<ver>.md` (nếu có dự án phía dưới) |
| Biến môi trường / cấu hình | `../reference/config.md` + `.env.example` |
| Breaking change | `../changelog/<ver>.md` |
| Quyết định kỹ thuật | `../decisions.md` (+ REQ bị ảnh hưởng) |
| Khuôn mẫu code / quy trình | `AGENTS.md` |
| **Đổi stack / công cụ build** | Lệnh trong `AGENTS.md` + CI + quy ước code + skill dự án — một change, không tách PR |

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
