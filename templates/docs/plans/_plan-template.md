# Kế hoạch Mxx — <tên>

Cập nhật: YYYY-MM-DD. Spec: SPEC-… (Ready). Thiết kế: <link>. Quyết định: D-…

## Trạng thái

| PR | Nhánh | Nội dung | AC | Phụ thuộc | Song song | Trạng thái |
|---|---|---|---|---|---|---|
| 1 | `feat/SPEC-XXX-<phần>` | | XXX-AC01..AC03 | — | | Chưa làm |
| 2 | `feat/SPEC-XXX-<phần>` | | XXX-AC04 | 1 | [P] với 3 | Chưa làm |

## Thứ tự và lý do

1. <PR> trước vì <phụ thuộc/rủi ro>.

## Dependency đã duyệt cho đợt này

| Package | Dùng ở PR | Theo |
|---|---|---|

## Checklist theo loại thay đổi

- **Đổi schema:** migration; <đồng bộ schema phụ>; mục trong `docs/upgrade/<ver>.md`.
- **Đổi API công khai:** contract; changeset; mục nâng cấp.
- **Chạm bảo mật:** trình kế hoạch trước khi code; nêu rõ trong PR.

## Ghi chú từng PR

1. **`feat/SPEC-XXX-<phần>`**
   - Ngữ cảnh tối thiểu: SPEC-XXX §4 (R01–R03), design §2; file `<…>`.
   - Test trước code: XXX-AC01..AC03 *(tầng)*.
   - Rủi ro:
