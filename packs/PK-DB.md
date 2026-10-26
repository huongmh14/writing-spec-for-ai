# PK-DB — Database, Schema & Migration

> Tín hiệu bật: Có cơ sở dữ liệu tự quản lý (PostgreSQL, MySQL, SQLite/D1, MongoDB…), ORM/query builder (Kysely, Prisma, EF Core, SQLAlchemy), hoặc thư mục `migrations/`
> Gốc ý tưởng (skill/repo tham khảo nội bộ, không phải bằng chứng): cdn, notification-service, dashboard, khaosatvmu, BotAutoTask + skill `migration`, `deprecation-and-migration`, `performance-optimization`

## Tham số

| Tham số | Mặc định | Mô tả |
|---|---|---|
| `{db-engine}` | `PostgreSQL` | Hệ quản trị CSDL và phiên bản chính (vd. `PostgreSQL 15`, `Cloudflare D1`, `SQLite 3`) |
| `{migrate-cmd}` | `npm run migrate` | Lệnh chạy migration tiến |
| `{seed-cmd}` | `npm run seed` | Lệnh khởi tạo dữ liệu mẫu / mặc định |
| `{max-tx-ms}` | `2000` | Thời gian tối đa giữ mở một transaction (ms) |
| `{default-batch-size}` | `500` | Kích thước lô tối đa khi cập nhật/di chuyển dữ liệu hàng loạt |

## REQ (EARS)

| ID | REQ |
|---|---|
| PK-DB-R01 | Khi thay đổi schema không tương thích ngược (đổi tên cột, đổi kiểu, xoá cột/bảng đang được đọc), hệ thống MUST thực hiện theo chuỗi **Expand–Migrate–Contract** (Mở rộng → Chuyển dữ liệu, kiểm chứng ngay trong bước này → Thu gọn; xem [glossary](../references/glossary.md)), trong đó bước xoá (`Contract`) tách sang PR/release sau khi toàn bộ code đọc/ghi đã chuyển sang cấu trúc mới. |
| PK-DB-R02 | Khi chạy `{migrate-cmd}` hoặc `{seed-cmd}` nhiều lần liên tiếp trên cùng môi trường, hệ thống MUST lũy đẳng (idempotent): không sinh lỗi, không tạo bản ghi trùng lặp, và trả mã thoát `≠ 0` nếu kết nối hoặc câu lệnh SQL thất bại. |
| PK-DB-R03 | Trong khi một DB transaction đang mở, hệ thống MUST NOT thực hiện lời gọi mạng ra bên ngoài (HTTP API, gửi email/webhook, hàng đợi bên ngoài) và thời gian giữ transaction MUST ≤ `{max-tx-ms}` ms. |
| PK-DB-R04 | Khi truy vấn danh sách hoặc xử lý hàng loạt trên bảng có thể tăng trưởng theo thời gian, hệ thống MUST giới hạn số bản ghi mỗi lần đọc/ghi (`LIMIT` ≤ `{default-batch-size}`) và tránh truy vấn lặp $N+1$ trong vòng lặp. |
| PK-DB-R05 | Mọi khoá ngoại hoặc cột xuất hiện trong điều kiện lọc (`WHERE`), sắp xếp (`ORDER BY`), hoặc ghép bảng (`JOIN`) trên đường nóng MUST có index tương ứng trong migration. |
| PK-DB-R06 | Mỗi bản migration MUST ghi rõ phương án quay lui (script `down` hoặc hướng dẫn rollback tương thích dữ liệu); nếu là migration một chiều không thể tự động hoàn tác, MUST khai báo rõ trong tài liệu thiết kế/upgrade và yêu cầu bước sao lưu trước khi chạy. |

## AC mẫu (Cho/Khi/Thì)

| ID | AC |
|---|---|
| PK-DB-AC01 | **Cho** CSDL đã chạy tới migration mới nhất. **Khi** chạy lại `{migrate-cmd}` và `{seed-cmd}` lần thứ hai. **Thì** lệnh trả exit code `0`, số lượng bản ghi seed không bị nhân đôi, và bảng schema xác nhận đúng trạng thái đích *(integration)*. |
| PK-DB-AC02 | **Cho** cấu hình kết nối DB sai hoặc SQL trong migration có lỗi cú pháp. **Khi** chạy `{migrate-cmd}`. **Thì** tiến trình dừng ngay, rollback phần dở dang (nếu engine hỗ trợ transactional DDL) và trả exit code `≠ 0` *(integration)*. |
| PK-DB-AC03 | **Cho** danh sách gồm 50 bản ghi cha có quan hệ con. **Khi** gọi hàm lấy danh sách kèm dữ liệu liên kết. **Thì** số câu truy vấn SQL phát sinh xuống `{db-engine}` là hằng số $O(1)$ (1–2 query dùng `JOIN` hoặc `WHERE IN`), không tăng tuyến tính theo 50 bản ghi *(integration)*. |
| PK-DB-AC04 | **Cho** migration đổi tên hoặc bỏ một cột đang có trên production. **Khi** kiểm tra PR đầu tiên. **Thì** migration chỉ thêm cột mới / dual-write (pha Expand), code phiên bản cũ vẫn đọc/ghi không lỗi trong suốt thời gian rollout *(contract/migration)*. |

## Dòng thêm vào AGENTS.md

### ✅ Luôn
- Viết migration mới: kiểm tra tính lũy đẳng và kiểm tra tác dụng thật trên bảng/cột sau khi chạy `{migrate-cmd}`.
- Thêm truy vấn trong vòng lặp: gom thành batch (`WHERE id IN (...)`) hoặc `JOIN` để tránh lỗi $N+1$.
- Thêm cột lọc/tìm kiếm thường xuyên: tạo index ngay trong cùng file migration.

### ⚠️ Hỏi trước
- Thêm, sửa, xoá bảng/cột hoặc thay đổi ràng buộc (`UNIQUE`, `NOT NULL`, `FOREIGN KEY`).
- Sửa hoặc xoá file migration đã được commit vào nhánh chính.
- Viết migration có thao tác xoá dữ liệu (`DROP COLUMN`, `DROP TABLE`, `DELETE`, `TRUNCATE`).

### 🚫 Không bao giờ
- Gọi HTTP/webhook/dịch vụ ngoài bên trong khối DB transaction đang mở.
- Nối chuỗi trực tiếp từ biến đầu vào vào câu lệnh SQL (bắt buộc dùng parameterized query / binding).
- Để `{migrate-cmd}` trả exit code `0` khi không áp dụng được migration hoặc khi nuốt lỗi kết nối.

## Mục khảo sát bổ sung (cho survey-project)

- Dự án dùng DB engine nào, ORM/query builder nào?
- Lệnh `{migrate-cmd}` và `{seed-cmd}` thực chất làm gì? Chạy thử hoặc đọc code xem có nuốt lỗi trả exit 0 không (bài học **Kiểm tác dụng lệnh vận hành**, `C19`)?
- Đã có migration nào sửa đè lên file migration cũ hoặc `DROP` trực tiếp không qua Expand–Migrate–Contract chưa?
- Có chỗ nào gọi `fetch` / gửi mail / bắn queue bên trong `db.transaction(...)` không?

## Gotchas

| Triệu chứng | Nguyên nhân | Cách tránh | Kiểm lần cuối |
|---|---|---|---|
| Pool kết nối DB cạn kiệt khi dịch vụ bên thứ ba (SMTP/Webhook) chậm | Gọi HTTP/SMTP bên trong `db.transaction()`, giữ lock và connection chờ mạng | Tách bước gọi mạng ra sau khi transaction đã commit hoặc đẩy qua bảng outbox / job nền | 2026-10-20 |
| Deploy zero-downtime bị lỗi 500 trong vài phút lúc chuyển giao | Migration `RENAME`/`DROP` cột ngay khi container bản cũ vẫn đang chạy | Áp dụng Expand–Migrate–Contract: thêm cột mới ở PR 1, xoá cột cũ ở PR 2 sau khi rollout xong | 2026-10-20 |
| `{migrate-cmd}` báo thành công trên CI nhưng bảng mới không tồn tại | Script wrapper bắt `catch` chỉ `console.error` rồi thoát bình thường (exit 0) | Kiểm tra tác dụng thật trên schema (`information_schema` / `sqlite_master`) trong AC | 2026-10-20 |
