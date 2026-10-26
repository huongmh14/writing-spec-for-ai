# Nhật ký tiến độ

## Đợt thực thi hiện tại (quyền thực thi theo đợt)

Chỉ có **một block hiện tại**. Đây là bản ghi chỉ dẫn thật của người dùng, không phải nơi AI tự cấp quyền. Chỉ dẫn hiện hành được ưu tiên; không hỏi lại phạm vi đã được giao rõ. Khi người dùng chưa đặt ranh giới: code **1 SPEC + 1 task/AC nhỏ**; docs **một bước con mỗi lượt** (5b: đúng 1 file SPEC + `specs/README.md`) rồi dừng chờ review; yêu cầu rõ batch/toàn spec hữu hạn thì ghi đủ ID tương ứng.

| Trường | Giá trị |
|---|---|
| RUN-ID | Chưa có |
| Trạng thái | Chưa cấp quyền |
| Chỉ dẫn người dùng | Chưa có — trích nguyên văn hoặc tham chiếu tin nhắn thật khi được giao; không tự tạo lời duyệt |
| SPEC / task / AC được giao | Chưa có |
| Vùng file dự kiến | Chưa có |
| Ngoài phạm vi | Mọi task/spec chưa được giao; không tự lấy việc từ danh sách task sẵn sàng |
| Điều kiện dừng | Làm → kiểm → báo cáo → dừng ở hết phạm vi được giao; hoặc nêu blocker ngăn phần còn lại |
| Bằng chứng / điều chưa kiểm chứng | Chưa chạy |
| Bàn giao phiên mới (ghi đè trước `/compact` hoặc khi đổi cửa sổ) | Việc đang dở trong đợt · Việc chỉ người làm được · Câu hỏi mở (link về spec; không cấp quyền chạy task kế) |

Vòng đời: `Chưa cấp quyền` → `Được phép` → `Đang làm` → `Chờ kiểm chứng` → `Đã đóng`. Chuyển sang `Được phép` chỉ khi có chỉ dẫn thật xác định phạm vi; AI được ghi nhận chỉ dẫn, không tự phê duyệt. Khi báo cáo đợt, cập nhật `Chờ kiểm chứng` rồi dừng; không tự gia hạn hoặc chọn task/spec khác. Đợt mới cần chỉ dẫn mới xác định phạm vi; lưu kết quả đợt cũ vào nhật ký trước khi thay block.

## Lịch sử

Mỗi dòng ≤ 3 câu. Khi file vượt ~5 KB (quy ước của bộ kit), chuyển lịch sử cũ sang `progress-archive/<năm>.md`, giữ block hiện tại ở đây.

| Ngày | RUN / Spec | Đã xong (AC + bằng chứng) | Còn dở / chưa kiểm chứng |
|---|---|---|---|
| YYYY-MM-DD | RUN-… / SPEC-… | | |
