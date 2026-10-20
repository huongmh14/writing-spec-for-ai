# Kế hoạch Mxx — <tên>

Cập nhật: YYYY-MM-DD. Spec: SPEC-… (Ready). Thiết kế: <link>. Quyết định: D-…

## 1. Đồ thị Task & Lát cắt dọc (`Tracer Bullets` / `Expand–Contract`)

<!-- Mỗi task thông thường là một lát cắt dọc (Tracer Bullet) đi xuyên schema → logic/API → UI/CLI → test AC-ID, sửa ≤ ~5 file. Thay đổi diện rộng dùng chuỗi Expand → Migrate → Contract. -->

| Mã Task | Tên hành vi đầu-cuối (hoặc bước Expand/Migrate/Contract) | REQ / AC nghiệm thu | `Blocked by` | Song song (`Frontier`) | Nhánh / PR | Trạng thái |
|---|---|---|---|---|---|---|
| `T-01` | | XXX-R01, XXX-AC01..AC02 | `None` | [P] với `T-02` | `feat/SPEC-XXX-<phần>` | `[ ]` |
| `T-02` | | XXX-R02, XXX-AC03 | `None` | [P] với `T-01` | `feat/SPEC-XXX-<phần>` | `[ ]` |
| `T-03` | | XXX-R03, XXX-AC04 | `T-01, T-02` | — | `feat/SPEC-XXX-<phần>` | `[ ]` |

## 2. Thứ tự và lý do

1. `<T-01>` trước vì `<phụ thuộc/prefactoring/rủi ro>`.

## 3. Dependency đã duyệt cho đợt này

| Package | Dùng ở Task/PR | Theo quyết định |
|---|---|---|

## 4. Checklist kích hoạt theo loại thay đổi

- **Đổi schema:** migration (`Expand–Contract`); <đồng bộ schema phụ>; mục trong `docs/upgrade/<ver>.md`.
- **Đổi API công khai:** contract máy đọc; changeset; mục nâng cấp.
- **Chạm bảo mật:** trình kế hoạch trước khi code; nêu rõ trong PR.

## 5. Chi tiết từng Task (`Context Pointers` cho Subagent)

### `T-01`: <Tên hành vi đầu-cuối>
- **Ngữ cảnh tối thiểu:** `SPEC-XXX` §4 (`XXX-R01`), `design` §2; file `<đường dẫn ≤ 5 file>`.
- **Blocked by:** `None`
- **Ma trận Kiểm thử Minh bạch (`Visible Test Matrix` — `C29`):**
  | AC-ID | Kịch bản | Input bơm vào | Output & Tác dụng phụ thực tế | Tầng & Độ thật (`0 Mock` / `Mock gì`) | Kết quả |
  |---|---|---|---|---|---|
  | `XXX-AC01` | <nhánh chính> | `<input cụ thể>` | `<HTTP / DB / DOM>` | `integration` (`0 Mock`) | `[ ]` |
- **Lệnh kiểm chứng (`Verify`):** `<lệnh chạy đúng 1 test chứa AC-ID>`
- **Rủi ro / Rollback:**
