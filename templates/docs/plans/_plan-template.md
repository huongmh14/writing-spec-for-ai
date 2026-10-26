# Kế hoạch Mxx — <tên>

Cập nhật: YYYY-MM-DD. Spec: SPEC-… (Ready). Thiết kế: <link>. Quyết định: D-…

**Đợt được phép thực thi (`C30`):** xem block hiện tại trong `../progress.md`. Plan này là danh sách công việc dự kiến, không tự cấp quyền chạy. Khi chưa có ranh giới khác từ người dùng, mỗi đợt chỉ 1 SPEC + 1 task; batch/toàn spec chỉ khi được giao rõ phạm vi hữu hạn.

## 1. Đồ thị Task & Lát cắt dọc (`Tracer Bullets` / `Expand–Contract`)

<!-- Mỗi task là một lát cắt dọc kiểm chứng được, dự kiến khoảng 5 file. Sửa hàm chung/caller cần thiết trong cùng hành vi được phép; ghi tác động. Thay đổi diện rộng dùng Expand → Migrate → Contract. Frontier chỉ thể hiện phụ thuộc, không là quyền chạy song song. -->

| Mã Task | Tên hành vi đầu-cuối (hoặc bước Expand/Migrate/Contract) | REQ / AC nghiệm thu | `Blocked by` | Song song (`Frontier`) | Nhánh / PR | Trạng thái |
|---|---|---|---|---|---|---|
| `T-01` | | XXX-R01, XXX-AC01..AC02 | `None` | [P] với `T-02` | `feat/SPEC-XXX-<phần>` | `[ ]` |
| `T-02` | | XXX-R02, XXX-AC03 | `None` | [P] với `T-01` | `feat/SPEC-XXX-<phần>` | `[ ]` |
| `T-03` | | XXX-R03, XXX-AC04 | `T-01, T-02` | — | `feat/SPEC-XXX-<phần>` | `[ ]` |

## 2. Thứ tự và lý do

1. `<T-01>` trước vì `<phụ thuộc/prefactoring/rủi ro>`.

## 3. Dependency đã duyệt cho kế hoạch

| Package | Dùng ở Task/PR | Theo quyết định |
|---|---|---|

## 4. Checklist kích hoạt theo loại thay đổi

- **Đổi schema:** migration (`Expand–Contract`); <đồng bộ schema phụ>; mục trong `docs/upgrade/<ver>.md`.
- **Đổi API công khai:** contract máy đọc; changeset; mục nâng cấp.
- **Chạm bảo mật:** đối chiếu phạm vi đã duyệt trước khi code; chỉ hỏi nếu chưa được giao, nêu rõ trong PR.
- **Kết thúc đợt:** cập nhật `../progress.md` sang `Chờ kiểm chứng`, đưa bằng chứng rồi dừng; không tự lấy task tiếp theo từ Frontier.

## 5. Chi tiết từng Task (`Context Pointers` cho Subagent)

### `T-01`: <Tên hành vi đầu-cuối>
- **Ngữ cảnh tối thiểu:** `SPEC-XXX` §4 (`XXX-R01`), `design` §2; file `<vùng file dự kiến>`; quyền thực thi chỉ lấy từ `../progress.md` và chỉ dẫn thật của người dùng.
- **Blocked by:** `None`
- **Ma trận Kiểm thử Minh bạch (`Visible Test Matrix` — `C29`):**
  | AC-ID | Kịch bản | Input dự kiến | Output & Tác dụng phụ kỳ vọng | Tầng & Độ thật (`0 Mock` / `Mock gì`) | Trạng thái chạy |
  |---|---|---|---|---|---|
  | `XXX-AC01` | <nhánh chính> | `<input cụ thể>` | `<HTTP / DB / DOM>` | `integration` (`0 Mock`) | `[ ]` |
- **Lệnh kiểm chứng (`Verify`):** `<lệnh chạy đúng 1 test chứa AC-ID>`
- **Điểm dừng:** `<hành vi/AC có thể demo; không tự chuyển task>`
- **Rủi ro / Rollback:**
