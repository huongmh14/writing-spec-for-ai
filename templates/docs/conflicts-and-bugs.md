# Sổ tay Lỗi, Xung đột Hợp đồng & Bài học Lịch sử (`conflicts-and-bugs.md`)

> Mục đích: Ghi nhận **mọi** lỗi thực tế (bug/hotfix/revert), xung đột hợp đồng liên module/repo (Enum DB, API route, Port, Schema, giới hạn phần cứng/UI) đã xảy ra trong dự án để:
> 1. AI Agent và Reviewer đối chiếu trước khi viết/duyệt code mới, không lặp lại lỗi cũ.
> 2. Làm nguồn dữ liệu chuẩn (Ground Truth) cho công cụ kiểm tra cơ học (`Gate 0`) và bộ kiểm thử hồi quy.

---

## 1. Bảng Tổng hợp Lỗi & Xung đột Đã Gặp

Mỗi khi phát hiện hoặc sửa xong một bug / xung đột / revert, **bắt buộc** thêm 1 dòng vào bảng dưới đây trước khi đóng đợt:

| ID | Ngày / Commit SHA | Phân loại (`Enum` / `API` / `DB` / `Port` / `UI` / `Logic`) | Mô tả triệu chứng & Xung đột | Nguyên nhân gốc (Root Cause) | Cách chặn tự động bằng máy (`Gate 0` / Test / Lint) | Ngày kiểm lần cuối |
|---|---|---|---|---|---|---|
| `BUG-01` | `YYYY-MM-DD` · `<sha>` | `<loại>` | `<chuyện gì đã xảy ra>` | `<vì sao AI/người viết gây lỗi>` | `<lệnh grep / test / constraint chặn lỗi này>` | `YYYY-MM-DD` |

---

## 2. Chi tiết Các Ca Điển hình (Dùng làm mẫu cho AI Review)

### `BUG-01` — <Tiêu đề ngắn gọn>
- **Vùng file bị ảnh hưởng:** `<path/to/file>`
- **Dấu hiệu nhận biết trong Diff (Smell):** `<mẫu code hoặc cấu hình sai>`
- **Hợp đồng đúng phải tuân thủ:** `<trích dẫn file SQL / OpenAPI / SPEC-xx / D-xx>`
- **Lệnh kiểm tra cơ học (0 token):**
  ```bash
  <lệnh kiểm tra nhanh>
  ```
