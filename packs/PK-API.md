# PK-API — HTTP API

> Tín hiệu bật: Có endpoint HTTP công khai
> Gốc ý tưởng (skill/repo tham khảo nội bộ, không phải bằng chứng): cdn, notification-service, dashboard

## Tham số

| Tham số | Mặc định | Mô tả |
|---|---|---|
| `{debug-flag}` | `DEBUG=false` | Biến môi trường bật debug mode; khi `true` cho phép trả message/stack cho lỗi 5xx |
| `{default-limit}` | `50` | Giá trị mặc định cho `limit` khi phân trang (người dùng không gửi) |
| `{max-limit}` | `100` | Giá trị tối đa cho `limit`; MUST kiểm tra server-side |
| `{allowed-origins}` | `["https://example.com"]` | Danh sách origin cho phép CORS trong production; dev có dùng `*` |
| `{health-path}` | `/health` | Đường dẫn health check |
| `{openapi-path}` | - | Đường dẫn file OpenAPI/Swagger nếu có; nếu có thì đó là nguồn thật cho contract |

## REQ (EARS)

| ID | REQ |
|---|---|
| PK-API-R01 | Hệ thống MUST trả mọi lỗi theo cùng một định dạng `{error, code, statusCode, details?}`; `code` nằm trong danh mục mã lỗi được định nghĩa. |
| PK-API-R02 | Nếu lỗi là 5xx, hệ thống MUST NOT trả message/stack trace cho client, trừ khi `{debug-flag}` được bật (không phải production). |
| PK-API-R03 | Input sai (thiếu trường, sai type, sai giá trị) MUST trả HTTP 400, `details` liệt kê lỗi theo từng trường. |
| PK-API-R04 | `GET {health-path}` MUST trả 200, không cần xác thực, không lộ thông tin nội bộ (version, stack, DB). |
| PK-API-R05 | Mọi endpoint trả danh sách (list, search, browse) MUST phân trang với response `{items, total, page, limit}`; `limit` MUST ≤ `{max-limit}`. |
| PK-API-R06 | Trong production, CORS MUST dùng danh sách origin cụ thể từ `{allowed-origins}`, không dùng `*`. |
| PK-API-R07 | Khi có contract máy đọc (OpenAPI tại `{openapi-path}`), file đó là nguồn thật; spec chỉ link tới, không chép lại. |

## AC mẫu (Cho/Khi/Thì)

| ID | AC |
|---|---|
| PK-API-AC01 | **Cho** endpoint trả danh sách. **Khi** client gửi `limit=200`. **Thì** hệ thống trả 400 với `details` ghi `limit` vượt `{max-limit}`. |
| PK-API-AC02 | **Cho** endpoint trả lỗi 5xx. **Khi** `{debug-flag}=false`. **Thì** response chỉ có `{error, code, statusCode}`, không có `details`. |
| PK-API-AC03 | **Cho** endpoint GET danh sách. **Khi** client không gửi `limit`. **Thì** hệ thống dùng `{default-limit}`. |
| PK-API-AC04 | **Cho** endpoint GET danh sách. **Khi** client gửi `limit=10`. **Thì** response có `{items, total, page, limit}` với `limit=10`. |
| PK-API-AC05 | **Cho** production. **Khi** có request origin không trong `{allowed-origins}`. **Thì** CORS header không được gửi. |

## Dòng thêm vào AGENTS.md

### ✅ Luôn
- Thêm endpoint mới: định nghĩa `{error, code, statusCode}` cho mọi lỗi.
- Định nghĩa mã lỗi mới: thêm vào `docs/reference/error-codes.md`.
- Endpoint trả danh sách: thêm phân trang `{items, total, page, limit}`.
- Bật CORS: cấu hình origin theo `{allowed-origins}` trong production.

### ⚠️ Hỏi trước
- Đổi định dạng error response.
- Thay đổi `{max-limit}`.
- Thêm endpoint health check khác `{health-path}`.
- Thay đổi `{openapi-path}` (đang dùng làm nguồn thật).

### 🚫 Không bao giờ
- Trả stack trace hoặc message lỗi nội bộ khi `{debug-flag}=false`.
- Dùng `*` cho CORS trong production.
- Endpoint trả danh sách không phân trang.

## Mục khảo sát bổ sung (cho survey-project)

- Có endpoint health check? Đường dẫn là gì?
- Có dùng CORS? Config hiện tại (origin whitelist vs `*`)?
- Có file OpenAPI/Swagger? Đường dẫn?
- Có endpoint trả danh sách? Phân trang theo format chuẩn chưa?
- Format error response hiện tại là gì? Có `{error, code, statusCode}` không?
- Có biến môi trường debug mode không?

## Gotchas

| Triệu chứng | Nguyên nhân | Cách tránh | Kiểm lần cuối |
|---|---|---|---|
| Lỗi 5xx nhưng response vẫn lộ stack trace trên production | `{debug-flag}` bị bật do lộn env hoặc default = true | Default MUST = false; validate env lúc khởi động | 2026-10-20 |
| Endpoint danh sách không phân trang, trả mảng lớn gây timeout | Quên REQ PK-API-R05 | Mọi endpoint list MUST phân trang theo spec | 2026-10-20 |
| CORS dùng `*` trên production vì dev config copy nguyên sang | Config env không tách dev/prod | Config riêng cho dev vs production; CI kiểm origin | 2026-10-20 |
