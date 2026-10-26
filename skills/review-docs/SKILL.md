---
name: review-docs
description: Dùng ở Bước 6 (Cổng 2) sau khi đã viết xong file docs/spec, hoặc khi người dùng nói "review docs", "chấm checklist", "phản biện Cổng 2". Chỉ mở ở Bước 6 để chạy spec-challenger trong phiên sạch và trình báo cáo; không mở trước khi viết xong docs.
---

# Review docs — phản biện đối kháng & tự kiểm trước khi trình duyệt (Cổng 2)

Đầu vào: danh sách file vừa viết/sửa (`ARTIFACT`) + đường dẫn `references/review-checklist.md`, các `packs/PK-*.md` đang bật (`CONTRACT` — truyền đường dẫn cho subagent `spec-challenger` đọc trong phiên sạch, phiên chính không tự nạp toàn bộ `references/base-kit.md` vào ngữ cảnh, `C17`).
Đầu ra: báo cáo gửi người dùng gồm (1) danh sách file, (2) kết quả chấm từng mục, (3) phân loại phát hiện phản biện & mọi mục `[ ]` kèm đề xuất sửa, (4) câu hỏi mở còn lại. **Mục `[ ]` không được giấu** — đó là thông tin người duyệt cần nhất.

> Gốc ý tưởng (skill tham khảo nội bộ, không phải bằng chứng): `doubt-driven-development` (luật Core **Phản biện trong phiên sạch**, `C26`), `pstack/interrogate`, `open-code-review-delegate`.

## 1. Quy trình Phản biện Đối kháng trong Context sạch (`C26`)

Người vừa viết tài liệu luôn mang thiên kiến xác nhận (confirmation bias). Vì vậy, khi kiểm tra ở Bước 6:

1. **Tách `ARTIFACT` và `CONTRACT` (Tuyệt đối không truyền `CLAIM`):**
   - Giao việc cho subagent chỉ đọc [`spec-challenger`](../../agents/spec-challenger.md) (hoặc chạy một lượt kiểm tra tách biệt hoàn toàn với lý lẽ lúc viết).
   - Chỉ cung cấp đường dẫn các file vừa viết (`ARTIFACT`) và [`references/review-checklist.md`](../../references/review-checklist.md) + các Pack đang bật (`CONTRACT`). Không kèm lời giải thích *"tôi viết thế này vì..."*.
2. *(Tuỳ chọn cho dự án lớn / rủi ro cao)* **Hỏi ý kiến model thứ hai:**
   - Nếu đang ở phiên tương tác và dự án có vùng bảo mật/kiến trúc phức tạp, hỏi người dùng có muốn chạy thêm một lượt phản biện chéo qua CLI model khác (`codex`, `gemini`, `claude` ở chế độ `--sandbox read-only`, truyền prompt qua file tạm `stdin`) hay không.
3. **Đối chiếu & Phân loại phát hiện (`RECONCILE`):**
   Đọc lại văn bản thật đối chiếu với từng phát hiện của `spec-challenger` và phân loại theo thứ tự ưu tiên:
   - **Loại 1 — Lỗi thật, sửa được ngay:** sửa thẳng vào file docs trước khi trình người dùng (xem bảng mục 2).
   - **Loại 2 — Cần quyết định:** hành vi/phạm vi/đánh đổi → hỏi người dùng bằng ví dụ; thiếu kiến thức kỹ thuật → AI nghiên cứu/thử nghiệm trong quyền đã giao hoặc đề nghị người có chuyên môn (**Nguồn & giới hạn hiểu biết**, `C31`), không bắt người dùng xác nhận điều chưa chứng minh.
   - **Loại 3 — Đánh đổi có chủ đích:** ghi rõ lý do hoặc gắn `ceiling:` (**Đánh dấu giới hạn đơn giản hoá**, `C27`) / `D-xx` để người dùng thấy.
   - **Loại 4 — Báo động giả do thiếu ngữ cảnh:** nếu người đọc mới hiểu nhầm vì câu chữ trong docs chưa rõ, hãy làm sắc nét câu chữ đó để người sau không hiểu nhầm tương tự.

## 2. Chấm theo [references/review-checklist.md](../../references/review-checklist.md) & Sửa nhanh

Chạy đủ 6 nhóm theo thứ tự; mỗi mục phải có **bằng chứng trong file** (đường dẫn + dòng/đoạn).

| Triệu chứng thấy được | Sửa ngay trước khi trình |
|---|---|
| Spec chỉ có chữ và bảng REQ, thiếu hình dung trực quan (**Trình bày định hướng bằng hình**, `C28`) | Thêm sơ đồ luồng Mermaid + ít nhất 1 **Snapshot I/O cụ thể** (ASCII wireframe / CLI / JSON mẫu) |
| AC chỉ ghi chữ chung chung, thiếu Ma trận Kiểm thử Minh bạch (**Bằng chứng test hiển thị**, `C29`) | Bổ sung Ma trận Kiểm thử Minh bạch nêu rõ `Input cụ thể / Output & Tác dụng phụ / Tầng & Độ thật (0 Mock hay Mock gì)` |
| REQ mơ hồ, chứa số không có nguồn, hoặc nhãn `Đã xác minh` mà con trỏ không chứa câu trích | Tìm cơ sở yêu cầu/số đo; chưa có → `Chưa biết` + cách xác minh, không tự điền ngưỡng (`C31`) |
| AC kết thúc bằng "hoạt động đúng" / lệnh vận hành chỉ kiểm exit 0 | Thay bằng mã HTTP, mã lỗi, dữ liệu DB/file sinh ra (**Kiểm tác dụng lệnh vận hành**, `C19`) |
| "Ngoài phạm vi" rỗng | Thêm ít nhất 1 thứ lân cận bị loại (phần GĐ sau, dịch vụ ngoài, màn không làm) |
| Spec `Ready` còn `[CẦN LÀM RÕ]` | Chuyển về `Draft` hoặc hỏi người dùng giải quyết trước khi trình |
| Sự thật xuất hiện ở 2 file | Chọn 1 nguồn thật (spec/contract/`config.md`/`error-codes.md`), chỗ còn lại chỉ đặt context pointer |
| Dòng trỏ file trong `AGENTS.md` chỉ ghi tên file chung chung | Viết lại theo mẫu **Con trỏ có điều kiện** (`C24`): *"Khi chạm <nhánh X> → đọc `<file Y>`"* |
| REQ kế thừa từ `PK-*` còn `{tham-số}` | Tìm giá trị có cơ sở; chưa có thì P-xx và giữ Draft, không đoán cho đủ mẫu |
| `Ready`/task sẵn sàng/HANDOFF bị coi là quyền code | Đối chiếu lệnh người dùng và đợt hiện tại; xác định điểm dừng (**Quyền thực thi theo đợt**, `C30`) |
| Có AC `[~]` nhưng spec `Done` | Trả về trạng thái chưa hoàn tất; nêu ai/cách kiểm chứng, không tính là pass |
| Lệnh trong `AGENTS.md` / `CONSTRAINTS.md` chưa chạy thử | Chạy thử nếu an toàn; không an toàn → ghi rõ "chưa chạy + lý do" trong báo cáo |

## 3. Format báo cáo Cổng 2

```markdown
## Kết quả tự kiểm & phản biện (Cổng 2)

File đã viết/sửa: <danh sách>

| Nhóm | Đạt | Chưa đạt | Không áp dụng |
|---|---|---|---|
| 1. AGENTS.md (gồm **Không hạ chuẩn âm thầm** `C23`, `C24`, `C27`) | … | … | |
| 2. Spec & Pack kế thừa | … | … | |
| 3. Quyết định, thuật ngữ, Capability Map | … | … | |
| 3b. CI, cấu hình, CONSTRAINTS, gotcha | … | … | |
| 4–6. Vị trí, chất lượng chung, Mức 1–2 | … | … | |

Đã tự sửa sau phản biện `spec-challenger`:
- <file:dòng> — <lỗi phát hiện> → <đã sửa thế nào>

Chưa đạt + kế hoạch (cần người dùng quyết định):
- <mục> — <lý do> — <đề xuất phương án>

Câu hỏi còn lại: <danh sách hoặc "Không có">
```

→ Gửi báo cáo, dừng, chờ duyệt (Cổng 2). Không tự chuyển sang Bước 7.

## Kiểm tra trước khi xong

- [ ] Đã chạy kiểm tra đối kháng với context tách biệt (`C26`).
- [ ] Mọi mục `[ ]` đều xuất hiện tường minh trong báo cáo.
- [ ] Mọi kết luận có bằng chứng đường dẫn trong file.
- [ ] Không file mới nào bị bỏ quên (không được trỏ tới, nằm ngoài git).
- [ ] Đã kiểm `C30–C31`; AI phản biện không thay nguồn sơ cấp/test/chuyên gia, báo cáo kiểm docs không chứng minh sản phẩm đã đúng.
