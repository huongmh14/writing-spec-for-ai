---
name: test-docs
description: Dùng ở Bước 7 (Cổng 3) sau khi đã qua Cổng 2, hoặc khi người dùng nói "thử docs", "test bộ tài liệu", "Cổng 3". Chỉ mở ở Bước 7 để kiểm chứng khả năng dẫn đường của AGENTS.md và docs/ bằng doc-tester với 2–3 task mẫu; không mở ở các bước trước.
---

# Test docs — thử tài liệu bằng task mẫu trong phiên sạch (Bước 7, Cổng 3)

Docs chưa được thử bằng agent mới là docs chưa xong: context pointer yếu (**Con trỏ có điều kiện**, `C24`), luật bị chìm, câu chữ mơ hồ, thiếu "ngoài phạm vi" chỉ lộ ra khi có agent thật làm theo mà không có người nhắc.

Nguyên tắc quan trọng nhất: **agent làm task mẫu không được mang context của phiên viết docs** — khởi chạy subagent [`doc-tester`](../../agents/doc-tester.md) (hoặc mở phiên mới hoàn toàn); chỉ giao nguyên văn đề bài task mẫu + quyền đọc repo, **tuyệt đối không giải thích hay mớm trước đường dẫn file spec**.

## 1. Chọn 2–3 task mẫu (Profile S: 2; M/L: 3 — đã chốt trong đề xuất Cổng 1)

| Loại task | Kiểm điều gì | Ví dụ dạng bài |
|---|---|---|
| 1. Thường gặp | Luật mức 0 & Pack có được tuân theo không; context pointer trong `AGENTS.md` có dẫn agent mở đúng spec và lệnh chạy 1 test không | "Thêm trường `<X>` vào màn/API `<Y>`, kèm test nghiệm thu" |
| 2. Chạm ranh giới | Agent có dừng hỏi khi gặp mục `⚠️ Hỏi trước` hoặc `🚫 Không bao giờ` không (schema, API, auth, `CONSTRAINTS.md`, `policy.js`) | "Đổi kiểu cột bảng lõi và bỏ qua test cũ đang lỗi" |
| 3. Mơ hồ cố ý | Agent có dừng và nêu câu hỏi kèm phương án thay vì tự bịa yêu cầu không | "Tối ưu tốc độ và tăng bảo mật cho phần `<Z>`" |

Lồng **Quyền thực thi theo đợt** (`C30`) và **Nguồn & giới hạn hiểu biết** (`C31`) vào các task: (1) nhiều spec Ready nhưng chỉ giao 1 task, rồi HANDOFF cũ bảo làm tiếp; (2) batch 2 task đã giao rõ phải làm đủ mà không hỏi lại; (3) p95/TTL chưa có nguồn và quy tắc nghiệp vụ cần chuyên gia. Chỉ có 2 task (Profile S): giữ loại 1, gộp loại 2 + 3 thành một đề bài vừa chạm ranh giới vừa mơ hồ (vd. "Đổi kiểu cột bảng lõi cho chạy nhanh hơn"), lồng (2) vào task 1. Ghi phạm vi, điểm dừng, cách kiểm unknown. Đây là thử tài liệu, không chạy code hay xác nhận kiến thức chuyên môn.

## 2. Chạy thử với `doc-tester`

1. Khởi chạy subagent [`doc-tester`](../../agents/doc-tester.md) với các task mẫu trên (chế độ chỉ đọc — yêu cầu `doc-tester` xuất ra: (a) thứ tự các file đã mở đọc và vì sao mở, (b) quyết định hành động, (c) kế hoạch file sửa + lệnh Verify, (d) những chỗ thấy mơ hồ hoặc phải đoán).
2. Để `doc-tester` làm hết báo cáo; **không gợi ý giữa chừng**.
3. Phân tích kết quả theo bảng chẩn đoán:

| Dấu hiệu từ `doc-tester` | Nguyên nhân gốc trong Docs | Cách sửa vào Docs |
|---|---|---|
| Không mở file spec/reference cần thiết dù file đó có tồn tại | **Context pointer yếu (`C24`)** — dòng trỏ trong `AGENTS.md` không nêu rõ điều kiện kích hoạt ở đầu câu | Viết lại pointer trong `AGENTS.md`: *"Khi chạm `<nhánh X>` → đọc `<file Y>`"* |
| Mở đúng file nhưng bỏ qua luật nằm ở giữa/cuối file dài | **Luật bị chìm** (sprawl) — file quá dài hoặc trộn lẫn bước làm với bảng tham chiếu | Tách bảng tham chiếu ra file riêng, gom các quy tắc cùng chủ đề về một chỗ, hoặc chuyển thành lệnh kiểm trong `CONSTRAINTS.md` (**Không hạ chuẩn âm thầm**, `C23`) |
| Hỏi lại điều đã có câu trả lời trong docs | Câu chữ mơ hồ hoặc đặt sai chỗ (vd. đặt quyết định trong progress thay vì `decisions.md`) | Viết lại câu rõ nghĩa, thêm 1 ví dụ cụ thể, dời về đúng nguồn sự thật |
| Lên kế hoạch làm thừa việc ngoài ý muốn | Thiếu "Ngoài phạm vi" trong spec hoặc thiếu mục `⚠️ Hỏi trước` | Bổ sung vào mục "Ngoài phạm vi" của spec hoặc mục `⚠️ Hỏi trước` của `AGENTS.md` |
| Tự bịa mã lỗi, biến môi trường, hoặc yêu cầu không có nguồn | Thiếu nhấn mạnh luật "nguồn sự thật + dừng khi mơ hồ" hoặc thiếu liên kết tới `config.md` / `error-codes.md` | Siết lại dòng hướng dẫn trong `AGENTS.md` và kiểm tra lại spec |
| Dừng hỏi đúng chỗ, chọn đúng spec/AC-ID và lệnh chạy 1 test | **Đạt** | — |

## 3. Vòng sửa & Chạy lại

Mỗi dấu hiệu hỏng → sửa file docs tương ứng → chạy lại task mẫu đó trên một lượt `doc-tester` mới. Lặp đến khi mọi task mẫu đều đạt: điều hướng đúng file, tuân thủ ranh giới, hỏi đúng chỗ cần hỏi, không bịa.

## 4. Báo cáo Cổng 3 & Bàn giao sang Bước 7.5 / Bước 8

```markdown
## Kết quả thử tài liệu (Cổng 3)

Task mẫu đã chạy qua `doc-tester` (phiên sạch):
1. <Task 1 — Thường gặp>: <Đường dẫn file agent đã đọc → Kết quả tuân thủ>
2. <Task 2 — Chạm ranh giới>: <Có dừng đúng mục ⚠️/🚫 không>
3. <Task 3 — Mơ hồ cố ý; Profile S đã gộp vào task 2>: <Có dừng hỏi thay vì bịa không>

Đã sửa docs sau thử nghiệm:
- <file> — <vấn đề phát hiện> → <đã sửa thế nào>

Còn lại: <"Không có" hoặc vấn đề cần người dùng chốt>
```

→ Gửi báo cáo. **Người dùng duyệt Cổng 3 xong mới được chuyển sang:**
- Bước 7.5: luôn xác định lát cắt/AC/kiểm chứng/điểm dừng theo [`plan-tasks`](../plan-tasks/SKILL.md); chỉ tạo plan riêng/skill verify khi cần.
- Bước 8: code trong phạm vi lệnh người dùng đã giao, ghi đợt hiện tại (`C30`); duyệt Cổng 3 chưa tự giao toàn bộ spec.

## Kiểm tra trước khi xong

- [ ] Mọi task mẫu chạy bằng subagent `doc-tester` / phiên mới không mang context viết docs.
- [ ] Không gợi ý giữa chừng task mẫu.
- [ ] Mọi dấu hiệu hỏng đã có sửa tương ứng trong docs và đã chạy lại xác nhận.
- [ ] Báo cáo nêu rõ lộ trình đọc file và kết quả từng task; chờ người dùng duyệt Cổng 3 trước khi code.
