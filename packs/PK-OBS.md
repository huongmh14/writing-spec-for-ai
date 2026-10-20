# PK-OBS — Observability, Structured Logging, Metrics & Runbooks

> Tín hiệu bật: Dịch vụ chạy dài hạn (HTTP server, worker, daemon, bot) trên môi trường staging/production cần chẩn đoán sự cố, theo dõi SLO hoặc cảnh báo on-call
> Nguồn: cdn, notification-service, dashboard, BotAutoTask + skill `observability-and-instrumentation`

## Tham số

| Tham số | Mặc định | Mô tả |
|---|---|---|
| `{correlation-header}` | `x-request-id` | Header HTTP hoặc khóa metadata dùng để truyền mã định danh truy vết xuyên dịch vụ |
| `{log-format}` | `json` | Định dạng xuất log trên production (`json` trên stdout/stderr) |
| `{metrics-path}` | `/metrics` | Đường dẫn phơi bày metrics (Prometheus / OpenTelemetry) nếu có |
| `{runbook-dir}` | `docs/runbooks/` | Thư mục lưu hướng dẫn xử lý sự cố ngắn gọn cho từng cảnh báo |

## REQ (EARS)

| ID | REQ |
|---|---|
| PK-OBS-R01 | Trên môi trường production, hệ thống MUST ghi log dưới dạng cấu trúc (`{log-format}`) với tên sự kiện cố định (`event`), mức log chuẩn (`error`, `warn`, `info`, `debug`), không nối chuỗi tự do làm mất khả năng truy vấn theo trường. |
| PK-OBS-R02 | Khi nhận một yêu cầu hoặc khởi chạy một tác vụ nền, hệ thống MUST nhận hoặc sinh mới mã định danh `{correlation-header}` (`requestId`/`runId`) kèm nhãn điểm vào (`entryPoint`: `http`, `scheduler`, `queue`, `cli`) và truyền cả hai qua mọi dòng log, span, cũng như lời gọi hạ nguồn. |
| PK-OBS-R03 | Hệ thống MUST NOT đưa các giá trị có tập hợp không bị chặn (unbounded cardinality như `user_id`, `email`, `requestId`, URL nguyên bản chứa ID, nội dung message lỗi) vào làm nhãn (`label`/`tag`) của metric. |
| PK-OBS-R04 | Với mọi endpoint hoặc lời gọi phụ thuộc bên ngoài (DB, Redis, API đối tác), hệ thống SHOULD thu thập đủ 3 tín hiệu RED: **R**ate (tần suất), **E**rrors (tỷ lệ lỗi theo phân lớp), và **D**uration (phân phối độ trễ dạng histogram tính được `p50`/`p95`/`p99`, không chỉ tính trung bình cộng). |
| PK-OBS-R05 | Khi định nghĩa một cảnh báo vận hành (Alert), cảnh báo MUST dựa trên triệu chứng người dùng cảm nhận (tỷ lệ lỗi, độ trễ `p99`, độ trễ hàng đợi) và đính kèm đường dẫn tới một runbook tối thiểu 3 dòng trong `{runbook-dir}` (Ý nghĩa · Câu lệnh kiểm tra đầu tiên · Đầu mối leo thang). |

## AC mẫu (Cho/Khi/Thì)

| ID | AC |
|---|---|
| PK-OBS-AC01 | **Cho** một request gửi kèm header `{correlation-header}: req-123` gây ra lỗi ở tầng dịch vụ. **Khi** kiểm tra luồng log xuất ra. **Thì** dòng log lỗi là một JSON hợp lệ chứa đúng `"requestId": "req-123"`, `"entryPoint": "http"`, mã `event` cố định, và không chứa secret/token *(integration)*. |
| PK-OBS-AC02 | **Cho** cùng một hàm xử lý job được gọi từ cả lịch tự động (`scheduler`) và lệnh chạy lại thủ công (`cli`). **Khi** hai luồng cùng ghi vào một đích log. **Thì** mỗi dòng log đều có trường `entryPoint` phân biệt rõ nguồn khởi phát mà không cần đoán qua thời điểm chạy *(unit/integration)*. |
| PK-OBS-AC03 | **Cho** bộ thu thập metric HTTP. **Khi** gọi 100 request với 100 `userId` và đường dẫn `/items/:id` khác nhau. **Thì** nhãn `route` trong metric được chuẩn hoá về mẫu `/items/:id` (không sinh 100 chuỗi thời gian riêng biệt theo từng ID) *(unit)*. |

## Dòng thêm vào AGENTS.md

### ✅ Luôn
- Ghi log sự kiện nghiệp vụ hoặc lỗi: dùng logger có cấu trúc (`logger.info({ event, requestId, entryPoint, ... })`), không dùng `console.log` ghép chuỗi tự do trong code nghiệp vụ.
- Truyền `requestId` và `entryPoint` qua context/metadata khi gọi hàm bất đồng bộ, đẩy hàng đợi hoặc gọi HTTP sang dịch vụ khác.
- Chỉ dùng tập giá trị hữu hạn, cố định (`route` mẫu, `status_class`, `provider`) làm nhãn cho metric.

### ⚠️ Hỏi trước
- Thêm nhãn (label) mới vào metric đang có trên production.
- Thay đổi tên trường chuẩn (`requestId`, `entryPoint`, `event`) trong cấu trúc JSON log.
- Thêm hoặc xoá cảnh báo (alert) vận hành.

### 🚫 Không bao giờ
- Đưa `user_id`, `email`, `requestId`, full URL, hoặc chuỗi lỗi tự do vào nhãn (`label`) của Prometheus/OpenTelemetry metric (gây nổ cardinality).
- Ghi toàn bộ `req.body` hoặc `req.headers` chưa qua bước lọc trường cho phép (allowlist) vào log.

## Mục khảo sát bổ sung (cho survey-project)

- Dự án đang dùng thư viện logger nào (Pino, Winston, Nest Logger, hay `console.log`)?
- Đã có cơ chế gắn và truyền `requestId` (`AsyncLocalStorage` / middleware) chưa?
- Các job chạy từ cron, queue và CLI có dùng chung hàm xử lý mà thiếu trường `entryPoint` phân biệt nguồn gọi không?
- Nếu có Prometheus/OpenTelemetry metrics, có nhãn nào đang gắn biến động (ID, URL thô) không?

## Gotchas

| Triệu chứng | Nguyên nhân | Cách tránh | Kiểm lần cuối |
|---|---|---|---|
| Máy chủ Prometheus/Metrics hết RAM hoặc treo sau khi lên production | Gắn `userId`, `requestId`, hoặc `req.url` chưa chuẩn hoá vào `labelNames` của metric | Chỉ gắn route template (`/users/:id`) và `status_class` (`2xx`, `4xx`, `5xx`); đẩy ID chi tiết sang log/trace | 2026-10-20 |
| Log ghi nhận job thất bại nhưng không biết do cron chạy tự động hay do ai chạy tay qua CLI | Chỉ truyền `runId` mà không truyền `entryPoint` tại nơi khởi phát | Khởi tạo child logger kèm `{ entryPoint, requestId }` ngay ở hàm điểm vào (`entryPoint`) của từng kênh | 2026-10-20 |
| Log in ra `"err": "[object Object]"` hoặc `{}` rỗng khi bắt ngoại lệ | Truyền đối tượng `Error` vào trường không được serializer hỗ trợ hoặc `JSON.stringify(err)` trực tiếp | Dùng chuẩn trường `err` của Pino hoặc trích rõ `{ errName: err.name, errMessage: err.message, errCode: err.code }` | 2026-10-20 |
