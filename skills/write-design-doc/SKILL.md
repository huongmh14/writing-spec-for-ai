---
name: write-design-doc
description: Dùng ở Bước 5c khi một spec cần > 2 PR, chạm schema dữ liệu, API công khai hoặc bảo mật/thanh toán, hoặc khi người dùng nói "viết design doc", "thiết kế cho SPEC-XXX". Tạo tài liệu thiết kế kiến trúc (Deep Modules, Seams, Design It Twice, mô hình đe doạ STRIDE và kế hoạch rollback).
---

# Write design doc — tài liệu thiết kế của một spec (Bước 5c)

Nguyên tắc phân vai: **spec nói cái gì, design nói ghép thế nào**. Nếu nội dung định viết trả lời được "yêu cầu nào?" thì thuộc spec; trả lời "chọn kiến trúc/giao diện nào, đặt điểm ghép nối (seam) ở đâu và tại sao?" thì thuộc design.

> Nguồn kế thừa: `codebase-design` (Deep Modules & Seams), `pstack/architect` (Design It Twice), `source-driven-development` (`C25`), `ponytail` (`C27`), `archify`.

Khi nào viết (tín hiệu, phải có thật trước khi mở file):
- Plan dự kiến của spec > 2 PR;
- Chạm schema dữ liệu, API công khai, hoặc cơ chế bảo mật;
- Có ≥ 2 phương án kiến trúc đáng kể đang phân vân (nếu không → design không cần, ghi một dòng vào "Ghi chú thiết kế" của spec là đủ).

## Các bước

1. **Viết từng file design một & dừng chờ review (`C30` — Checkpoint 5c):** Tạo **ĐÚNG 1 file** `docs/specs/<nn>-<khu-vực>-design.md` từ `templates/docs/specs/_design-template.md` (bảng Thuộc tính link về spec); sau khi viết xong file này, trình tóm tắt ngắn cho người dùng và **BẮT BUỘC DỪNG LẠI** chờ người dùng review/duyệt trước khi viết file design khác hoặc chuyển sang Bước 6 (`review-docs`).
2. **Bối cảnh và ràng buộc**: chỉ liệt kê ràng buộc *ảnh hưởng chọn phương án* (từ `decisions.md` D-xx, `CONSTRAINTS.md`, AGENTS.md, hạ tầng). Không tả lại spec.
3. **Thiết kế Module Sâu & Điểm ghép nối (`Deep Modules & Seams`):**
   - Sơ đồ luồng (Mermaid) cho luồng chính + luồng lỗi (nếu người dùng cần bản HTML tương tác để duyệt thiết kế phức tạp, dùng thêm skill `archify`).
   - Bảng `Thành phần (Module) | Giao diện & Điểm ghép nối (Interface & Seam) | Trách nhiệm ẩn bên trong | REQ` — ưu tiên **Deep Module** (giao diện nhỏ, ít hàm/tham số nhưng ẩn được nhiều logic phức tạp bên trong) thay vì Shallow Module (giao diện phình to chỉ làm nhiệm vụ truyền tay).
   - Chỉ rõ **Seam (điểm ghép nối)** nơi đặt bài test nghiệm thu để test toàn bộ hành vi từ bên ngoài mà không phải mock sâu vào ruột cài đặt.
   - **Trích dẫn nguồn chính thống (`C25`):** mọi mẫu thiết kế gắn với framework/thư viện phải kiểm đúng major version trong manifest và đính link tài liệu chính thức (hoặc gắn `[UNVERIFIED]` nếu chưa xác minh được).
   - **Đánh dấu trần đơn giản hoá (`C27`):** nếu cố ý chọn thiết kế đơn giản có giới hạn đã biết (in-memory queue, lock đơn tiến trình, polling), ghi rõ `ceiling: <ngưỡng chịu tải tối đa> → <đường nâng cấp khi vượt ngưỡng>`.
4. **Mô hình dữ liệu**: bảng thực thể + trường chính + ràng buộc + vòng đời. Thay đổi schema có sẵn → ghi rõ đường migration tương thích ngược (**Expand → Migrate → Verify → Contract** theo `PK-DB-R01`).
5. **Hợp đồng**: link file máy đọc (`openapi.yaml#/paths/...`, JSON Schema, test vectors). **Không chép nội dung contract vào design** — một sự thật một chỗ.
6. **Mô hình đe doạ** (vùng rủi ro auth/phân quyền/dữ liệu cá nhân/thanh toán/agent): bảng `Tài sản | Mối đe doạ (STRIDE) | Biện pháp | REQ/AC` — mọi biện pháp phải truy về REQ/AC, biện pháp nào không có REQ thì bổ sung REQ vào spec (cùng PR).
7. **Phương án đã loại (`Design It Twice`)**: với vùng thiết kế cốt lõi, bắt buộc phác thảo tối thiểu **2 phương án có hình thái giao diện khác nhau**, so sánh độ sâu giao diện (Interface Depth), độ cô lập thay đổi (Locality) và chi phí vận hành, rồi ghi rõ vì sao loại phương án kia. Thiếu mục này = design chưa xong.
8. **Rủi ro, migration, rollback**: chuyện gì hỏng khi triển khai, quay lại thế nào, có mất dữ liệu không.
9. **Đối chiếu nguyên tắc**: bảng rà từng nguyên tắc AGENTS.md / D-xx / `CONSTRAINTS.md` liên quan — Đạt / Vi phạm + lý do.

## Gotchas

- Design phình thành bản mô tả lại spec (copy REQ) → xoá phần không trả lời "ghép thế nào".
- Đặt quá nhiều seam/adapter giả định khi thực tế chỉ có 1 cách cài đặt (*"One adapter means a hypothetical seam; two adapters means a real one"*).
- Phương án đã loại chỉ dựng "bù nhìn" (strawman) hoặc ghi một từ "không phù hợp" → phải là phương án khả thi thực sự và nêu lý do kỹ thuật đủ để người sau không đề xuất lại.

## Kiểm tra trước khi trình

- [ ] Có tín hiệu đủ điều kiện viết design (liệt kê ở đầu skill).
- [ ] Mỗi thành phần maps về REQ; chỉ rõ **Interface Depth** và **Seam** đặt test.
- [ ] Các quyết định phụ thuộc framework/API có link tài liệu chính thức đúng version (`C25`); các chỗ đơn giản hoá có chủ đích có ghi chú `ceiling:` (`C27`).
- [ ] Contract là file máy đọc, design chỉ link.
- [ ] Có ≥ 1 phương án đối trọng thực sự đã loại kèm lý do (**Design It Twice**).
- [ ] Vùng rủi ro: có bảng STRIDE, biện pháp truy về REQ/AC.
- [ ] Có rollback; đổi schema có đường migration Expand–Contract; dừng chờ người dùng review sau khi viết xong 1 file design (`C30` — Checkpoint 5c).
