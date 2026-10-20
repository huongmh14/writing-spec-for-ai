---
name: propose-doc-design
description: Lập đề xuất thiết kế bộ tài liệu cho AI agent của một dự án — AGENTS.md, CONSTRAINTS.md, glossary, decisions, Capability Map & danh sách spec theo khu vực, plans, adapters, hook — kèm Profile S/M/L, Pack PK-*, câu hỏi làm rõ theo Frontier + HYPOTHESIS/GUESS và kế hoạch thử tài liệu; dừng chờ người dùng duyệt (Cổng 1), chưa tạo file nào trong repo. Dùng sau khi khảo sát, hoặc khi người dùng nói "đề xuất docs", "thiết kế tài liệu cho AI", "Cổng 1".
---

# Propose doc design — đề xuất thiết kế docs (Bước 3–4 của writing-spec-for-ai)

Đầu vào: kết quả `survey-project` (bảng hiện trạng + Profile + mức + Pack).
Đầu ra: MỘT file đề xuất theo `templates/doc-design-proposal.md`, lưu ở thư mục artifact của phiên (hoặc `docs/proposals/` nếu người dùng muốn). **Chưa tạo bất kỳ file docs thật nào trong repo.**

→ Gửi đề xuất, dừng, chờ duyệt (Cổng 1). Không duyệt thì sửa đề xuất, không lách sang viết docs.

## 1. Điền đề xuất từ kết quả khảo sát

- Mục 1 (hiện trạng): chép bảng khảo sát, giữ nguyên cột bằng chứng.
- Mục 2 (mức, profile, pack): chọn **Profile** (`S/M/L` theo [`profiles.md`](../../profiles.md)), chỉ giữ thành phần mức 1–2 có tín hiệu (`CONSTRAINTS.md`, `DESIGN-xx`, `verify-<app>`…), chọn **Pack** theo tín hiệu trong 8 pack (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`).
- Mục 3 (cây file): mỗi file ghi rõ Tạo / Sửa / Di chuyển / Xoá — repo có sẵn docs thì ưu tiên sửa/di chuyển, không tạo bản sao thứ hai.
- Mục 4 (nội dung `AGENTS.md` & `CONSTRAINTS.md`): viết sẵn các giá trị chính — lệnh, 3 tầng ranh giới, DoD, context pointers có điều kiện kích hoạt ở đầu câu (`C24`), dòng khai báo base/profile/pack.
- Mục 7 (cưỡng chế/hook/skill): chỉ đề xuất khi có tín hiệu; ghi luật nào rút thành check trong `CONSTRAINTS.md` được.

## 2. Chia bộ spec theo khu vực & Capability Map (mục 5 của đề xuất) — phần quan trọng nhất

Cách chia, theo thứ tự (kế thừa `spec-driven-development` Phase 0):

1. Liệt kê **thực thể và năng lực miền** từ tài liệu nguồn/khảo sát: người dùng, đơn, vai trò, kho, thông báo, báo cáo…
2. Gom thành các khu vực độc lập có thể kiểm thử riêng, mỗi khu vực trả lời *"ai dùng tính năng này để làm gì"*. Đặt tên theo miền (`RBAC`, `ORDERS`, `NOTIF`), không theo tầng kỹ thuật.
3. Tách riêng các spec **phương tiện** mọi phần cùng phải theo: `ARCH`, `REPO`, `API`, `NFR` — chỉ khi dự án đủ lớn (nhiều module/team).
4. **Xác định chiều phụ thuộc một chiều (`Depends on`) & Thứ tự xây dựng (`Build Order`):**
   - Mỗi dòng bảng: `SPEC-<TÊN> | Trách nhiệm khu vực | Phụ thuộc vào (Depends on) | Trạng thái dự kiến (Draft/As-built) | Nguồn yêu cầu`.
   - Mũi tên phụ thuộc chỉ đi một chiều, **cấm vòng lặp**. Nếu 2 module phụ thuộc lẫn nhau, chúng là 1 module hoặc phải tách phần giao diện chung ra trước.
5. Kiểm khối lượng: 1 spec ≈ 10–25 REQ. Khu vực lớn hơn → tách; nhỏ hơn 5 REQ → gộp.
6. **REQ từ pack:** nếu dự án bật pack (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`), ghi REQ kế thừa bằng bảng kèm giá trị tham số `{…}` cụ thể thay vì chép lại lý do (xem `base-kit.md` §7.2).

## 3. Câu hỏi làm rõ theo `HYPOTHESIS + Frontier + GUESS` (mục 10)

Rút từ mọi `[CẦN LÀM RÕ]` phát hiện được khi điền đề xuất. Áp dụng kỷ luật phỏng vấn từ `interview-me` và `grilling`:

1. **Nêu giả thuyết & Độ tự tin (`HYPOTHESIS + CONFIDENCE %`):** Mở đầu phần làm rõ bằng 1 câu tóm tắt cách bạn đang hiểu mục tiêu/ràng buộc của dự án kèm `%` độ tự tin và những gì còn khuyết.
2. **Chỉ hỏi các câu trên Mặt trận (`Frontier`):** Xem các quyết định như một cây thiết kế (design tree). Chỉ hỏi những câu mà tiền đề của nó đã rõ; câu nào phụ thuộc vào đáp án của câu trước thì để lượt sau, tối đa **≤ 5 câu** mỗi lượt, câu ảnh hưởng kiến trúc/phạm vi đứng đầu.
3. **Đính kèm phương án đề xuất (`➡️ GUESS / Đề xuất`):** Mỗi câu hỏi bắt buộc có phương án bạn khuyến nghị kèm lý do và hệ quả nếu chọn khác, viết sao cho người dùng chỉ cần trả lời `"Đồng ý"` là chốt được ngay.
4. **Bóc tách Buzzwords & Không nhận uỷ quyền mơ hồ:**
   - Nếu người dùng trả lời bằng từ khoá chung chung (*"cần scalable, clean, hiện đại"*), hỏi thẳng ngưỡng cụ thể hoặc *"Nếu không phải giải trình với ai, bạn thực sự cần điều gì chạy được trước?"*.
   - Không coi câu trả lời *"Tuỳ bạn"* / *"Sao cũng được"* là đã chốt cho quyết định kiến trúc — hãy rút gọn thành 2 lựa chọn cụ thể A/B nêu rõ cái giá phải trả của mỗi bên để người dùng chọn.
5. Đáp án là quyết định kiến trúc/quy tắc → ghi `D-xx`; là yêu cầu hành vi → ghi vào mục "Làm rõ" của spec.

## 4. Kế hoạch thử docs (mục 8) & Cố ý không làm (mục 9)

- Chọn sẵn 2–3 task mẫu sẽ giao cho subagent [`doc-tester`](../../agents/doc-tester.md) ở Cổng 3: 1 task thường gặp, 1 task chạm ranh giới "Hỏi trước", 1 task mơ hồ cố ý.
- Ghi rõ thứ đề xuất **bỏ qua** và lý do (mục 9) để người duyệt biết là đã cân nhắc, không quên.

## Kiểm tra trước khi xong

- [ ] Chưa file docs nào trong repo được tạo/sửa.
- [ ] Mọi thành phần mức 1–2 và Pack được chọn đều có tín hiệu đi kèm.
- [ ] Bảng chia bộ spec có cột `Depends on` một chiều (không vòng lặp) + `Build Order` + nguồn yêu cầu truy được.
- [ ] Mục câu hỏi mở đầu bằng `HYPOTHESIS + CONFIDENCE %`, ≤ 5 câu thuộc Frontier, mỗi câu có `➡️ Đề xuất (GUESS)`.
