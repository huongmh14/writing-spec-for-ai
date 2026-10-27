---
name: write-design-doc
description: Dùng ở Bước 5c (sau khi đã có SPEC-XXX) khi spec cần > 2 PR, chạm schema/API/bảo mật, hoặc khi người dùng nói "viết design doc cho SPEC-XXX". Chỉ mở ở Bước 5c để viết 1 file design (Deep Modules, Seams, Design It Twice, STRIDE, rollback); không mở ở bước khác.
---

# Write design doc — tài liệu thiết kế của một spec (Bước 5c)

Nguyên tắc phân vai: **spec nói cái gì, design nói ghép thế nào**. Nếu nội dung định viết trả lời được "yêu cầu nào?" thì thuộc spec; trả lời "chọn kiến trúc/giao diện nào, đặt điểm ghép nối (seam) ở đâu và tại sao?" thì thuộc design.

> Gốc ý tưởng (skill tham khảo nội bộ, không phải bằng chứng): `codebase-design`, `pstack/architect`, `source-driven-development` (**Dẫn nguồn chính thống**, `C25`), `ponytail` (**Đánh dấu giới hạn đơn giản hoá**, `C27`), `archify`. Khái niệm mượn: Deep Module, Design It Twice (John Ousterhout, *A Philosophy of Software Design*); Seam (Michael Feathers, *Working Effectively with Legacy Code*); STRIDE (Microsoft, Kohnfelder & Garg 1999); Expand–Migrate–Contract (Parallel Change — Danilo Sato, martinfowler.com/bliki/ParallelChange.html). Nghĩa ngắn: [glossary](../../references/glossary.md).

Khi nào viết (tín hiệu, phải có thật trước khi mở file):
- Plan dự kiến của spec > 2 PR;
- Chạm schema dữ liệu, API công khai, hoặc cơ chế bảo mật;
- Có ≥ 2 phương án kiến trúc đáng kể đang phân vân (nếu không → design không cần, ghi một dòng vào "Ghi chú thiết kế" của spec là đủ).

## Các bước

1. **Mỗi lượt một bước con, phản biện chéo & dừng chờ review (**Quyền thực thi theo đợt**, `C30` & `C26` — Checkpoint 5c):** lượt này chỉ làm bước 5c — tạo `docs/specs/<nn>-<khu-vực>-design.md` từ `templates/docs/specs/_design-template.md` (bảng Thuộc tính link về spec), không kèm spec mới hay bước khác; chạy 1 lượt phản biện độc lập (CLI model thứ hai read-only hoặc `spec-challenger` chỉ nhận `ARTIFACT + CONTRACT`), tự sửa lỗi thật trước khi trình tóm tắt + phần giải thích kỹ thuật cho người dùng và **BẮT BUỘC DỪNG LẠI** chờ review trước khi sang Bước 6 (`review-docs`).
2. **Bối cảnh và ràng buộc**: chỉ liệt kê ràng buộc *ảnh hưởng chọn phương án* (từ `decisions.md` D-xx, `CONSTRAINTS.md`, AGENTS.md, hạ tầng). Không tả lại spec.
3. **Thiết kế Module Sâu & Điểm ghép nối (`Deep Modules & Seams`):**
   - Sơ đồ luồng (Mermaid) cho luồng chính + luồng lỗi (nếu người dùng cần bản HTML tương tác để duyệt thiết kế phức tạp, dùng thêm skill `archify`).
   - Bảng `Thành phần (Module) | Giao diện & Điểm ghép nối (Interface & Seam) | Trách nhiệm ẩn bên trong | REQ` — ưu tiên **Deep Module** (giao diện nhỏ, ít hàm/tham số nhưng ẩn được nhiều logic phức tạp bên trong) thay vì Shallow Module (giao diện phình to chỉ làm nhiệm vụ truyền tay).
   - Chỉ rõ **Seam (điểm ghép nối)** nơi đặt bài test nghiệm thu để test toàn bộ hành vi từ bên ngoài mà không phải mock sâu vào ruột cài đặt.
   - **Trích dẫn nguồn chính thống (`C25`):** mọi mẫu thiết kế gắn với framework/thư viện phải kiểm đúng major version trong manifest và đính link tài liệu chính thức (hoặc gắn `[UNVERIFIED]` nếu chưa xác minh được).
   - **Đánh dấu trần đơn giản hoá (`C27`):** nếu cố ý chọn thiết kế đơn giản có giới hạn đã biết (in-memory queue, lock đơn tiến trình, polling), ghi rõ `ceiling: <ngưỡng chịu tải tối đa> → <đường nâng cấp khi vượt ngưỡng>`.
4. **Mô hình dữ liệu**: bảng thực thể + trường chính + ràng buộc + vòng đời. Thay đổi schema có sẵn → ghi rõ đường migration tương thích ngược (**Expand–Migrate–Contract**: Mở rộng → Chuyển dữ liệu, kiểm chứng ngay trong bước này → Thu gọn; theo `PK-DB-R01`).
5. **Hợp đồng**: link file máy đọc (`openapi.yaml#/paths/...`, JSON Schema, test vectors). **Không chép nội dung contract vào design** — một sự thật một chỗ.
6. **Mô hình đe doạ** (vùng rủi ro auth/phân quyền/dữ liệu cá nhân/thanh toán/agent): bảng `Tài sản | Mối đe doạ (STRIDE: giả mạo, sửa trái phép, chối bỏ, lộ thông tin, từ chối dịch vụ, leo quyền) | Biện pháp | REQ/AC` — mọi biện pháp phải truy về REQ/AC, biện pháp nào không có REQ thì bổ sung REQ vào spec (cùng PR).
7. **Phương án đã loại (Design It Twice — phác ≥ 2 phương án rồi mới chọn)**: với vùng thiết kế cốt lõi, bắt buộc phác thảo tối thiểu **2 phương án có hình thái giao diện khác nhau**, so sánh độ sâu giao diện, độ cô lập thay đổi và chi phí vận hành, rồi ghi rõ vì sao loại phương án kia (sinh và trình phương án theo [explore-options](../explore-options/SKILL.md); người dùng chọn). Thiếu mục này = design chưa xong. Mỗi cơ chế hoặc quyết định đáng kể (phương án, schema, thư viện, cơ chế bảo mật) ghi bằng **Thẻ giải thích & quyết định kỹ thuật** theo `templates/docs/specs/_design-template.md` (*Bản chất là gì + ví dụ · Tại sao bắt buộc cần / nếu bỏ qua thì lỗi gì · Chạy thế nào · Tự kiểm trong ≤ 5 phút · Nguồn & Không tự kiểm được*) để người dùng hiểu thấu kiến thức kỹ thuật AI viết và nghiệm thu qua bước Tự kiểm.
8. **Rủi ro, migration, rollback**: chuyện gì hỏng khi triển khai, quay lại thế nào, có mất dữ liệu không.
9. **Đối chiếu nguyên tắc**: bảng rà từng nguyên tắc AGENTS.md / D-xx / `CONSTRAINTS.md` liên quan — Đạt / Vi phạm + lý do.

## Gotchas

- Design phình thành bản mô tả lại spec (copy REQ) → xoá phần không trả lời "ghép thế nào".
- Đặt quá nhiều seam/adapter giả định khi thực tế chỉ có 1 cách cài đặt (*một adapter là seam giả định; hai adapter mới là seam thật*).
- Phương án đã loại chỉ dựng "bù nhìn" (strawman) hoặc ghi một từ "không phù hợp" → phải là phương án khả thi thực sự và nêu lý do kỹ thuật đủ để người sau không đề xuất lại.

## Kiểm tra trước khi trình

- [ ] Có tín hiệu đủ điều kiện viết design (liệt kê ở đầu skill).
- [ ] Mỗi thành phần maps về REQ; chỉ rõ **độ sâu giao diện** và **Seam** đặt test.
- [ ] Các quyết định phụ thuộc framework/API có link tài liệu chính thức đúng version (`C25`); các chỗ đơn giản hoá có chủ đích có ghi chú `ceiling:` (`C27`).
- [ ] Contract là file máy đọc, design chỉ link.
- [ ] Có ≥ 1 phương án đối trọng thực sự đã loại kèm lý do (**Design It Twice**); mỗi quyết định đáng kể có Thẻ quyết định với dòng Tự kiểm rẻ, chạy được.
- [ ] Vùng rủi ro: có bảng STRIDE, biện pháp truy về REQ/AC.
- [ ] Có rollback; đổi schema có đường migration Expand–Migrate–Contract; dừng chờ người dùng review sau bước 5c (`C30` — Checkpoint 5c).
