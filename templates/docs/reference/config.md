# Tham chiếu cấu hình

Một chỗ duy nhất cho mọi biến môi trường và file cấu hình. Spec chỉ link tới đây. Thêm/đổi biến thì sửa file này + `.env.example` trong cùng PR.

Ứng dụng validate cấu hình lúc khởi động và báo gộp mọi lỗi một lần.

## Biến môi trường

| Biến | Bắt buộc | Mặc định | Nhạy cảm | Mô tả / ràng buộc |
|---|---|---|---|---|
| `<TÊN_BIẾN>` | Có / Không | `<giá trị>` hoặc — | Có / Không | <ý nghĩa; ràng buộc: tối thiểu 32 ký tự, giá trị cho phép…> |

## File cấu hình

| File | Ai sửa | Commit? | Mô tả |
|---|---|---|---|
| `<đường dẫn>` | Người / máy sinh ra | Có / Không (mẫu: `<file>.example`) | |

## Khác nhau theo môi trường <!-- xoá nếu chỉ có một môi trường -->

| Biến | dev | staging | production |
|---|---|---|---|
