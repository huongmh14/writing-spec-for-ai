# PK-JOB — Background Jobs, Queues, Cron & Daemons

> Tín hiệu bật: Có tiến trình chạy nền (worker, consumer hàng đợi RabbitMQ/Redis/BullMQ/Cloudflare Queues, lịch định kỳ cron/scheduler, hoặc daemon đồng bộ dữ liệu)
> Nguồn: cdn, notification-service, citad-crawler-work-schedule, BotAutoTask, vmu-deploy-tool + skill `principle-make-operations-idempotent`, `observability-and-instrumentation`

## Tham số

| Tham số | Mặc định | Mô tả |
|---|---|---|
| `{job-timeout-ms}` | `60000` | Thời gian tối đa cho phép một lần thực thi job chạy trước khi bị huỷ (ms) |
| `{max-attempts}` | `3` | Số lần thử lại tối đa khi gặp lỗi tạm thời (transient error) |
| `{lock-ttl-ms}` | `120000` | Thời gian sống (TTL) của khoá chống chạy chồng lấn (lease/distributed lock) |
| `{shutdown-grace-ms}` | `15000` | Thời gian chờ tối đa để worker hoàn tất job đang dở khi nhận tín hiệu dừng (`SIGTERM`) |

## REQ (EARS)

| ID | REQ |
|---|---|
| PK-JOB-R01 | Khi cùng một thông điệp (message) hoặc tác vụ định kỳ được thực thi lại nhiều hơn một lần (do at-least-once delivery hoặc retry), hệ thống MUST đảm bảo tính lũy đẳng (idempotent) dựa trên khoá định danh nghiệp vụ (`idempotencyKey` / `jobId` + trạng thái đích), không tạo tác dụng phụ trùng lặp (gửi 2 lần cùng một thông báo, trừ tiền 2 lần, chèn đúp bản ghi). |
| PK-JOB-R02 | Mỗi lần thực thi job MUST bị giới hạn bởi `{job-timeout-ms}` ms; nếu gặp lỗi tạm thời (mạng, rate-limit `429`, dịch vụ đích `503`), hệ thống MUST thử lại tối đa `{max-attempts}` lần theo chiến lược lùi mũ có nhiễu (exponential backoff with jitter), và MUST NOT retry các lỗi vĩnh viễn (dữ liệu đầu vào sai định dạng, lỗi xác thực `401`/`403`). |
| PK-JOB-R03 | Nếu một job vẫn thất bại sau `{max-attempts}` lần thử hoặc gặp lỗi vĩnh viễn, hệ thống MUST chuyển job đó sang vùng cách ly (Dead-Letter Queue hoặc trạng thái `FAILED`/`DEAD` trong DB kèm nguyên nhân lỗi cuối cùng và số lần đã thử) để không làm tắc nghẽn các job tiếp theo. |
| PK-JOB-R04 | Với các tác vụ chạy theo lịch định kỳ (cron/scheduler) hoặc quét bảng dữ liệu dùng chung, hệ thống MUST sử dụng cơ chế khoá/lease có thời hạn (`{lock-ttl-ms}` ms, kiểm tra và cập nhật nguyên tử — CAS/atomic lock) để ngăn hai tiến trình hoặc hai chu kỳ liên tiếp xử lý trùng cùng một mục. |
| PK-JOB-R05 | Khi tiến trình worker nhận tín hiệu dừng (`SIGTERM` hoặc `SIGINT`), hệ thống MUST ngừng nhận job mới ngay lập tức, chờ tối đa `{shutdown-grace-ms}` ms để các job đang chạy hoàn tất hoặc nhả lease về trạng thái an toàn trước khi thoát. |

## AC mẫu (Cho/Khi/Thì)

| ID | AC |
|---|---|
| PK-JOB-AC01 | **Cho** một job có `idempotencyKey = "notif-100"` đã được xử lý thành công. **Khi** cùng message đó được đẩy lại vào worker lần thứ hai. **Thì** hệ thống nhận diện đã xử lý, bỏ qua bước gây tác dụng phụ bên ngoài, đánh dấu hoàn tất và trả kết quả an toàn *(integration)*. |
| PK-JOB-AC02 | **Cho** dịch vụ đích luôn trả lỗi tạm thời `503`. **Khi** worker xử lý job với `{max-attempts} = 3`. **Thì** job được thử đúng 3 lần với khoảng chờ tăng dần, sau lần thứ 3 được chuyển sang trạng thái `DEAD`/DLQ kèm thông tin lỗi và hàng đợi tiếp tục xử lý job kế tiếp *(unit/integration)*. |
| PK-JOB-AC03 | **Cho** hai tiến trình worker cùng quét lấy một job đang ở trạng thái `PENDING` tại cùng một thời điểm. **Khi** cả hai cùng thực hiện câu lệnh chiếm quyền xử lý (CAS lease). **Thì** chỉ có đúng 1 worker nhận được job, worker còn lại nhận `0` dòng cập nhật và không chạy trùng *(integration)*. |

## Dòng thêm vào AGENTS.md

### ✅ Luôn
- Viết handler cho job/queue/cron mới: thiết kế khoá lũy đẳng (`idempotencyKey`) trước khi viết logic xử lý.
- Phân loại lỗi trong worker: tách bạch lỗi tạm thời (được retry) và lỗi dữ liệu/logic vĩnh viễn (chuyển thẳng sang DLQ/failed).
- Đặt `AbortSignal.timeout({job-timeout-ms})` cho mọi lời gọi I/O bên trong worker.

### ⚠️ Hỏi trước
- Thay đổi cấu trúc payload của message trong hàng đợi (cần tương thích ngược với các message cũ đang nằm chờ trong queue).
- Thay đổi `{max-attempts}`, `{lock-ttl-ms}`, hoặc cơ chế chiếm giữ lease.

### 🚫 Không bao giờ
- Để vòng lặp `while (true)` hoặc lời gọi mạng trong worker chạy không có timeout.
- Nuốt lỗi trong job consumer (ack message thành công khi thực tế xử lý thất bại mà không ghi vào DLQ/bảng lỗi).
- Đổi kiểu hoặc xoá trường trong job payload ngay lập tức khi vẫn còn message phiên bản cũ chưa tiêu thụ hết.

## Mục khảo sát bổ sung (cho survey-project)

- Dự án có những cron job, queue consumer, hay vòng lặp daemon nào?
- Nếu cùng một job chạy 2 lần liên tiếp (do mạng đứt lúc vừa xử lý xong nhưng chưa kịp ack), chuyện gì xảy ra?
- Khi cron lần trước chạy lâu hơn chu kỳ cron (vd. cron mỗi 1 phút nhưng chạy mất 90 giây), lần chạy sau có đè lên lần chạy trước không?
- Tiến trình worker có bắt `SIGTERM` để dừng êm (graceful shutdown) khi redeploy container không?

## Gotchas

| Triệu chứng | Nguyên nhân | Cách tránh | Kiểm lần cuối |
|---|---|---|---|
| Một message lỗi cú pháp làm toàn bộ hàng đợi kẹt cứng (poison pill) | Worker ném lỗi làm message bị trả lại đầu hàng đợi và retry vô hạn | Giới hạn `{max-attempts}` và bắt lỗi dữ liệu không hợp lệ đẩy thẳng sang DLQ | 2026-10-20 |
| Job bị kẹt vĩnh viễn ở trạng thái `PROCESSING` sau khi container worker bị OOM kill | Đặt cờ `status = 'PROCESSING'` nhưng không có cột `lease_expires_at` (`{lock-ttl-ms}`) | Luôn kèm `lease_expires_at`; chỉ cho phép chiếm lại job khi `lease_expires_at < NOW()` | 2026-10-20 |
| Redeploy làm mất dở dang các tác vụ đang chạy | Docker gửi `SIGTERM` nhưng app không lắng nghe hoặc bị `SIGKILL` cắt ngang | Đăng ký handler `SIGTERM` ngừng nhận việc mới và hoàn tất việc đang chạy trong `{shutdown-grace-ms}` | 2026-10-20 |
