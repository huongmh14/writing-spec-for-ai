---
name: review-docs
description: Tự kiểm bộ tài liệu AI theo checklist trước khi trình người dùng duyệt (Cổng 2) — AGENTS.md, từng spec, decisions/glossary, vị trí adapter theo công cụ, chất lượng chung, thành phần mức 1–2; lập báo cáo nêu rõ mục chưa đạt và câu hỏi còn lại. Dùng sau khi viết hoặc sửa docs, hoặc khi người dùng nói "review docs", "kiểm tra spec", "chấm checklist", "Cổng 2".
---

# Review docs — tự kiểm trước khi trình duyệt (Cổng 2)

Đầu vào: danh sách file vừa viết/sửa.
Đầu ra: báo cáo gửi người dùng gồm (1) danh sách file, (2) kết quả chấm từng mục, (3) mọi mục `[ ]` kèm lý do và đề xuất sửa, (4) câu hỏi mở còn lại. **Mục `[ ]` không được giấu** — đó là thông tin người duyệt cần nhất.

## 1. Chấm theo [references/review-checklist.md](../../references/review-checklist.md)

Chạy đủ 6 nhóm theo thứ tự; chỉ bỏ nhóm 6 (mức 1–2) khi đề xuất không có thành phần mức 1–2.

Cách chấm một mục: tìm **bằng chứng trong file** (đường dẫn + dòng/đoạn), không chấm theo trí nhớ. Không tìm thấy bằng chứng → `[ ]`, không suy diễn "chắc có".

## 2. Lỗi hay gặp và cách sửa ngay khi review

| Triệu chứng thấy được | Sửa |
|---|---|
| REQ chứa "nhanh", "linh hoạt", "hợp lý" | Thay số ngưỡng hoặc chuyển câu hỏi mở |
| AC kết thúc bằng "hoạt động đúng" | Thay mã HTTP/mã lỗi/dữ liệu cụ thể |
| "Ngoài phạm vi" rỗng | Tìm ít nhất 1 thứ lân cận bị loại (thường là: phần GĐ sau, dịch vụ bên ngoài, màn không làm) |
| Spec `Ready` còn `[CẦN LÀM RÕ]` | Chuyển về Draft hoặc giải quyết trước khi trình |
| Sự thật xuất hiện ở 2 file | Chọn nguồn (thường là spec/contract), chỗ còn lại link |
| Lệnh trong AGENTS.md chưa chạy thử | Chạy nếu an toàn; không an toàn → ghi rõ "chưa chạy + lý do" trong báo cáo |
| File docs không file nào trỏ tới | Thêm link từ README/AGENTS.md tương ứng, hoặc ghi trong báo cáo |

Sửa được ngay thì sửa thẳng vào file rồi ghi vào báo cáo "đã sửa khi review". Không sửa được (thiếu quyết định người dùng) → để `[ ]` + câu hỏi.

## 3. Format báo cáo

```
## Kết quả tự kiểm (Cổng 2)

File đã viết/sửa: <danh sách>

| Nhóm | Đạt | Chưa đạt | Không áp dụng |
|---|---|---|---|
| 1. AGENTS.md | … | … | |
| 2. Spec | … | … | |

Chưa đạt + kế hoạch:
- <mục> — <lý do> — <đề xuất: sửa thế nào / cần quyết định gì>

Câu hỏi còn lại: <danh sách hoặc "Không có">
```

→ Gửi báo cáo, dừng, chờ duyệt. Không tự chuyển sang Bước 7.

## Kiểm tra trước khi xong

- [ ] Mọi mục `[ ]` đều xuất hiện trong báo cáo.
- [ ] Mọi kết luận có bằng chứng đường dẫn trong file.
- [ ] Không file mới nào bị bỏ quên (không được trỏ tới, nằm ngoài git).
