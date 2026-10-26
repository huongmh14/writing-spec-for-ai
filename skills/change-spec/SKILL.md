---
name: change-spec
description: Dùng ở Bước 8 khi cần đổi yêu cầu của một spec đã Ready/Done, hoặc khi người dùng nói "lập change proposal CHG-xx", "cập nhật SPEC đã duyệt". Chỉ mở khi sửa spec đã duyệt (ADDED/MODIFIED/REMOVED); không mở khi viết spec mới.
---

# Change spec — thay đổi spec đã duyệt

Spec `Draft`/`As-built` (spec mô tả code đã có) chưa được duyệt → sửa trực tiếp trong phạm vi đã giao. Spec `Ready`/`In progress`/`Done` đổi nghĩa REQ/AC → quy trình này, kể cả chưa code; sửa lỗi chính tả/link không đổi nghĩa thì sửa trực tiếp.

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
5. Đối chiếu đợt hiện tại trong `docs/progress.md` (**Quyền thực thi theo đợt**, `C30`): CHG được duyệt không tự cấp quyền thực thi ngoài phạm vi đã giao. Thu hồi phần quyền dựa vào REQ/AC đã đổi, chỉ tiếp tục khi lệnh người dùng bao phủ nội dung mới.
6. Spec từng `Done` có AC mới hoặc mất bằng chứng thì bỏ `Done`: đổi yêu cầu chưa chốt giữ `Draft`; yêu cầu đã chốt và chưa có đợt thì `Ready`, đang thực thi thì `In progress`. Đồng bộ danh mục; không tự duyệt yêu cầu bằng cách đổi trạng thái.

## 4. Đóng P-xx

Đề xuất chưa chốt nằm ở bảng `P-xx` trong `decisions.md`. Khi có kết luận: thêm dòng `D-xx` (trạng thái Hiệu lực), dòng P-xx cũ **xoá khỏi bảng** (không để mục đã làm xong nằm lại). Vòng đời: `P-xx (đề xuất) → D-xx (chốt) → sửa REQ/spec cùng PR`.

## Gotchas

- Nối thẳng phần lớn vào spec `Ready` — lỗi phổ biến nhất; spec phình, chuỗi truy vết gãy.
- Đổi REQ mà quên sửa AC tương ứng → AC chứng minh điều không còn đúng.
- Proposal ghi "sửa một chút cho linh hoạt" — không định lượng; MODIFIED phải có nguyên văn cũ để so.
- decisions đổi giá trị (vd. ngưỡng rate limit) mà REQ giữ số cũ → mâu thuẫn hai nguồn sự thật.

## Kiểm tra trước khi trình

- [ ] Đã chọn đúng đường đi (spec con vs CHG) theo bảng 3 câu.
- [ ] MODIFIED có nguyên văn cũ → mới; REMOVED chỉ deprecated, không xoá ID.
- [ ] Đổi giá trị thì REQ tương ứng sửa cùng PR.
- [ ] Tác động liệt kê đủ (migration/API/nâng cấp); "Không có" phải thật sự không có.
- [ ] Bảng P-xx không còn mục đã đóng.
