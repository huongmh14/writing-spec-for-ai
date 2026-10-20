---
name: test-docs
description: Thử bộ tài liệu AI bằng cách giao agent mới (không mang context cũ) làm 2–3 task mẫu đại diện, ghi lại luật bị bỏ qua, câu hỏi thừa, việc làm thừa; sửa docs theo kết quả rồi xin người dùng duyệt trước khi code (Cổng 3). Dùng khi người dùng nói "thử docs", "test tài liệu", hoặc trước khi bắt đầu code theo bộ spec mới.
---

# Test docs — thử tài liệu bằng task mẫu (Bước 7, Cổng 3)

Docs chưa được thử bằng agent mới là docs chưa xong: luật bị chìm, câu chữ mơ hồ, thiếu "ngoài phạm vi" chỉ lộ ra khi có agent thật làm theo.

Nguyên tắc quan trọng nhất: **agent làm task mẫu không được mang context của phiên viết docs** — dùng phiên mới / subagent mới; giao đúng loại thông tin một agent bình thường nhận được (AGENTS.md + spec liên quan), không giải thích thêm.

## 1. Chọn task mẫu (đã chốt trong đề xuất Cổng 1)

| Loại task | Kiểm điều gì | Ví dụ dạng bài |
|---|---|---|
| Thường gặp | Luật mức 0 có được tuân theo không; agent tự tìm được lệnh, spec đúng chỗ không | "Thêm trường <X> vào màn <Y>, kèm test" |
| Chạm ranh giới | Agent có dừng hỏi khi gặp mục "Hỏi trước" không (schema, API, bảo mật) | "Đổi cột bảng lõi sang kiểu khác" |
| Mơ hồ cố ý | Agent có dừng và nêu câu hỏi thay vì bịa không | "Cải thiện bảo mật cho phần <Z>" |

## 2. Chạy thử

1. Mở phiên/subagent mới; giao task nguyên văn như người dùng sẽ nói, kèm theo đúng những file docs đã có.
2. Để agent làm hết hoặc đến khi tự dừng; **không gợi ý giữa chừng**.
3. Ghi lại theo bảng:

| Dấu hiệu | Kết luận | Sửa docs thế nào |
|---|---|---|
| Agent bỏ qua luật nằm trong file dài | Luật bị chìm | Cắt file / nhấn mạnh dòng đó / chuyển thành hook-check |
| Agent hỏi lại điều đã có trong docs | Câu chữ mơ hồ hoặc đặt sai chỗ | Viết lại câu, thêm ví dụ, dời về đúng tầng |
| Agent làm thừa việc ngoài ý | Thiếu "Ngoài phạm vi" / thiếu ranh giới | Thêm mục ngoài phạm vi, bổ sung tầng ⚠️ |
| Agent dừng hỏi đúng chỗ | Đạt | — |
| Agent bịa yêu cầu không có nguồn | Thiếu luật "nguồn sự thật + dừng khi mơ hồ" | Nhấn mạnh ở AGENTS.md; kiểm spec có phần bịa |

## 3. Vòng sửa

Mỗi dấu hiệu hỏng → sửa file docs tương ứng → chạy lại task mẫu đó (vẫn phiên mới). Lặp đến khi 2–3 task đều đạt: agent tuân luật, hỏi đúng chỗ cần hỏi, không bịa.

## 4. Báo cáo Cổng 3

```
## Kết quả thử tài liệu (Cổng 3)

Task mẫu: <danh sách>
Kết quả từng task: <tuân thủ gì — hỏi gì — bịa gì>
Đã sửa docs: <file — thay đổi>
Còn lại: <vấn đề chưa giải quyết hoặc "Không có">
```

→ Gửi báo cáo. **Người dùng đồng ý mới được bắt đầu code** (Bước 8: code theo đúng quy trình bộ docs định nghĩa).

## Kiểm tra trước khi xong

- [ ] Mọi task mẫu chạy bằng phiên/subagent không mang context viết docs.
- [ ] Không gợi ý giữa chừng task mẫu.
- [ ] Mọi dấu hiệu hỏng đã có sửa tương ứng trong docs và đã chạy lại.
- [ ] Báo cáo nêu rõ kết quả từng task; chưa trình người duyệt quyết định code.
