---
name: write-design-doc
description: Viết tài liệu thiết kế đi kèm một spec (docs/specs/<nn>-<khu-vực>-design.md) khi spec cần hơn 2 PR hoặc chạm schema, API công khai, bảo mật — gồm thành phần, luồng, mô hình dữ liệu, contract máy đọc, mô hình đe doạ, phương án đã loại, rủi ro và rollback. Dùng khi đề xuất được duyệt có yêu cầu mức 1 "tài liệu thiết kế", hoặc khi người dùng nói "viết design", "thiết kế cho SPEC-XXX".
---

# Write design doc — tài liệu thiết kế của một spec

Nguyên tắc phân vai: **spec nói cái gì, design nói ghép thế nào**. Nếu nội dung định viết trả lời được "yêu cầu nào?" thì thuộc spec; trả lời "chọn kiến trúc/giao diện nào và tại sao?" thì thuộc design.

Khi nào viết (tín hiệu, phải có thật trước khi mở file):
- Plan dự kiến của spec > 2 PR;
- Chạm schema dữ liệu, API công khai, hoặc cơ chế bảo mật;
- Có ≥ 2 phương án kiến trúc đáng kể đang phân vân (nếu không → design không cần, ghi một dòng vào "Ghi chú thiết kế" của spec là đủ).

## Các bước

1. Tạo `docs/specs/<nn>-<khu-vực>-design.md` từ `templates/docs/specs/_design-template.md`; bảng Thuộc tính link về spec.
2. **Bối cảnh và ràng buộc**: chỉ liệt kê ràng buộc *ảnh hưởng chọn phương án* (từ `decisions.md` D-xx, AGENTS.md, hạ tầng). Không tả lại spec.
3. **Thiết kế**: sơ đồ luồng (mermaid) cho luồng chính + luồng lỗi; bảng `Thành phần | Trách nhiệm | REQ` — mỗi thành phần phải maps về ≥ 1 REQ, mỗi REQ "ghép thế nào" phải có thành phần nhận trách nhiệm.
4. **Mô hình dữ liệu**: bảng thực thể + trường chính + ràng buộc + vòng đời. Thay đổi schema có sẵn → ghi rõ migration đường đi.
5. **Hợp đồng**: link file máy đọc (`openapi.yaml#/paths/...`, JSON Schema, test vectors). **Không chép nội dung contract vào design** — một sự thật một chỗ.
6. **Mô hình đe doạ** (vùng rủi ro auth/phân quyền/dữ liệu cá nhân/thanh toán): bảng `Tài sản | Mối đe doạ (STRIDE) | Biện pháp | REQ/AC` — mọi biện pháp phải truy về REQ/AC, biện pháp nào không có REQ thì bổ sung REQ vào spec (cùng PR).
7. **Phương án đã loại**: ≥ 1 dòng cho mỗi phương án từng cân nhắc, ghi vì sao loại. Thiếu mục này = design chưa xong (đây là chỗ người review nhìn vào đầu tiên).
8. **Rủi ro, migration, rollback**: chuyện gì hỏng khi triển khai, quay lại thế nào, có mất dữ liệu không.
9. **Đối chiếu nguyên tắc**: bảng rà từng nguyên tắc AGENTS.md / D-xx liên quan — Đạt / Vi phạm + lý do (vi phạm có thể chấp nhận, nhưng phải nêu).

## Gotchas

- Design phình thành bản mô tả lại spec (copy REQ) → xoá phần không trả lời "ghép thế nào".
- Sơ đồ vẽ miên man nhưng bảng REQ → thành phần thiếu → không truy vết được nghiệm thu.
- Phương án đã loại chỉ ghi một từ "không phù hợp" → phải có lý do cụ thể đủ để người sau không đề xuất lại.

## Kiểm tra trước khi trình

- [ ] Có tín hiệu đủ điều kiện viết design (liệt kê ở đầu skill).
- [ ] Mỗi thành phần maps về REQ; mỗi REQ khó có thành phần nhận trách nhiệm.
- [ ] Contract là file máy đọc, design chỉ link.
- [ ] Có ≥ 1 phương án đã loại kèm lý do.
- [ ] Vùng rủi ro: có bảng STRIDE, biện pháp truy về REQ/AC.
- [ ] Có rollback; đổi schema có đường migration.
