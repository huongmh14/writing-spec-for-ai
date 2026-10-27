# Thuật ngữ & Giải thích Khái niệm Kỹ thuật

Spec, code và giao diện dùng đúng thuật ngữ ở đây. Thêm thuật ngữ mới khi viết spec hoặc design.

## 1. Thuật ngữ miền nghiệp vụ

| Thuật ngữ | Định nghĩa | Không gọi là | Tên trong code |
|---|---|---|---|
| <Nhóm> | <tập user cùng chức danh, mang quyền> | <role, vai trò> | `Group` |

## 2. Giải thích khái niệm & cơ chế kỹ thuật dùng trong dự án

Mọi thuật ngữ/cơ chế kỹ thuật chuyên sâu AI đưa vào spec, design hoặc code phải được giải thích tại đây bằng lời thường để người đọc hiểu bản chất.

| Khái niệm kỹ thuật | Bản chất nói dễ hiểu (kèm ví dụ trong dự án) | Tại sao dự án cần (bỏ qua thì lỗi gì?) | Nơi áp dụng (`SPEC-xx` / module) |
|---|---|---|---|
| `<Ví dụ: Idempotency Key (Khoá chống xử lý trùng)>` | `<Mã gắn cho mỗi lần bấm nút để nếu mạng lag gửi lặp 2 lần, hệ thống nhận ra và chỉ xử lý 1 lần>` | `<Nếu không có, khách bấm Thanh toán 2 lần sẽ bị trừ tiền đúp>` | `SPEC-PAY` |
