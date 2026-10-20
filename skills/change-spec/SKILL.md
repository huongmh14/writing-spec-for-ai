---
name: change-spec
description: Thay đổi spec đã Ready hoặc Done đúng quy trình — chọn giữa spec con, change proposal CHG-xx (ADDED/MODIFIED/REMOVED) và cập nhật decisions P-xx/D-xx; áp dụng delta vào spec sau khi được duyệt. Dùng khi yêu cầu đổi sau khi spec đã duyệt, khi phát hiện spec sai trong khi code, hoặc khi người dùng nói "sửa spec", "change proposal", "cập nhật đặc tả".
---

# Change spec — thay đổi spec đã duyệt

Phát hiện spec sai/thiếu **trước khi code** → sửa trực tiếp, spec vẫn Draft/Ready chưa ai làm thì không cần proposal. Cần quy trình của skill này khi spec đã `Ready`/`Done` và đã có người/agent làm theo.

## 1. Chọn đường đi (hỏi 3 câu theo thứ tự)

| Câu hỏi | Đúng → đường đi |
|---|---|
| Phần mới là **khu vực khác** của hệ thống, có thể đứng riêng? | **Spec con mới** (`write-spec`), spec cũ chỉ link. |
| Phần mới lớn (nhiều REQ) nhưng cùng khu vực, chưa ai làm? | Spec con hoặc đợt giai đoạn mới trong spec `Draft` — không nối vào spec `Ready`. |
| Đổi/huỷ REQ đã có, hoặc thêm ít REQ vào spec đã `Ready`/`Done`? | **Change proposal CHG-xx** (skill này). |

## 2. Viết proposal

Tạo `docs/changes/CHG-<số>-<slug>/proposal.md` từ `templates/docs/changes/_proposal-template.md`:

- **ADDED** — REQ mới, đánh số tiếp chuỗi cũ của spec (không đánh lại số cũ).
- **MODIFIED** — ghi rõ `cũ: … → mới: …` nguyên văn REQ cũ. Đổi giá trị trong REQ thì **cùng PR** phải sửa REQ (không chỉ ghi ở decisions).
- **REMOVED** — không xoá ID; đánh dấu deprecated + lý do. AC tương ứng cũng deprecated.
- **Tác động**: migration, API công khai, dự án phía dưới, tài liệu nâng cấp — mỗi mục "Không có" nếu thật sự không có.
- Gắn quyết định: thay đổi này là một quyết định → thêm dòng `D-xx` vào `decisions.md`, proposal chỉ link.

Trạng thái proposal: `Đề xuất` → trình người dùng duyệt → `Đã duyệt` → áp dụng.

## 3. Áp dụng sau khi duyệt (cùng PR)

1. Sửa file spec đúng theo ADDED/MODIFIED/REMOVED — gồm cả bảng AC và danh mục ở `docs/specs/README.md`.
2. AC bị MODIFIED mất hiệu lực cũ → chuyển `[ ]`, ghi ở "Làm rõ" của spec: ngày + CHG-id.
3. Chuyển proposal sang `Đã áp dụng`, di chuyển vào `docs/changes/archive/`.
4. Nếu AC đã `[x]` mà REQ đổi nghĩa → hạ về `[ ]`, test tương ứng sửa theo, chạy lại.

## 4. Đóng P-xx

Đề xuất chưa chốt nằm ở bảng `P-xx` trong `decisions.md`. Khi có kết luận: thêm dòng `D-xx` (trạng thái Hiệu lực), dòng P-xx cũ **xoá khỏi bảng** (không để mục đã làm xong nằm lại). Vòng đời: `P-xx (đề xuất) → D-xx (chốt) → sửa REQ/spec cùng PR`.

## Gotchas

- Nối thẳng phần lớn vào spec `Ready` — lỗi phổ biến nhất; spec phình, chuỗi truy vết gãy.
- Đổi REQ mà quên sửa AC tương ứng → AC chứng minh điều không còn đúng.
- Proposal ghi "sửa một chút cho linh hoạt" — không quantified; MODIFIED phải có nguyên văn cũ để so.
- decisions đổi giá trị (vd. ngưỡng rate limit) mà REQ giữ số cũ → mâu thuẫn hai nguồn sự thật.

## Kiểm tra trước khi trình

- [ ] Đã chọn đúng đường đi (spec con vs CHG) theo bảng 3 câu.
- [ ] MODIFIED có nguyên văn cũ → mới; REMOVED chỉ deprecated, không xoá ID.
- [ ] Đổi giá trị thì REQ tương ứng sửa cùng PR.
- [ ] Tác động liệt kê đủ (migration/API/nâng cấp); "Không có" phải thật sự không có.
- [ ] Bảng P-xx không còn mục đã đóng.
