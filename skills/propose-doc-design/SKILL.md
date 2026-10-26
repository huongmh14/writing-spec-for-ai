---
name: propose-doc-design
description: Dùng ở Bước 3–4 (Cổng 1) ngay sau khi khảo sát dự án, hoặc khi người dùng nói "đề xuất docs", "thiết kế tài liệu cho AI", "Cổng 1". Lập bản đề xuất kiến trúc tài liệu AI (Capability Map, Profile S/M/L, Pack PK-*, câu hỏi làm rõ theo Frontier + HYPOTHESIS/GUESS) và dừng chờ người dùng duyệt trước khi tạo file trong repo.
---

# Propose doc design — đề xuất thiết kế docs (Bước 3–4 của writing-spec-for-ai)

Đầu vào: kết quả `survey-project` (bảng hiện trạng + Profile + mức + Pack).
Đầu ra: MỘT file đề xuất theo `templates/doc-design-proposal.md`, lưu ở thư mục artifact của phiên (hoặc `docs/proposals/` nếu người dùng muốn). **Chưa tạo bất kỳ file docs thật nào trong repo.**

→ Gửi đề xuất, dừng, chờ duyệt (Cổng 1). Không duyệt thì sửa đề xuất, không lách sang viết docs.

## 1. Điền đề xuất từ kết quả khảo sát

- Mục 1 (hiện trạng): chép bảng khảo sát, giữ nguyên cột bằng chứng.
- Mục 2 (mức, profile, pack): chọn **Profile** (`S/M/L` theo [`profiles.md`](../../profiles.md)), chỉ giữ thành phần Mức 1–2 (thêm khi có tín hiệu; Mức 0 luôn bắt buộc — [glossary](../../references/glossary.md)) có tín hiệu (`CONSTRAINTS.md`, `DESIGN-xx`, `verify-<app>`…), chọn **Pack** theo tín hiệu trong 8 pack (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`).
- Mục 3 (cây file): mỗi file ghi rõ Tạo / Sửa / Di chuyển / Xoá — repo có sẵn docs thì ưu tiên sửa/di chuyển, không tạo bản sao thứ hai.
- Mục 4 (nội dung `AGENTS.md` & `CONSTRAINTS.md`): viết sẵn các giá trị chính — lệnh, 3 tầng ranh giới, DoD, context pointers có điều kiện kích hoạt ở đầu câu (**Con trỏ có điều kiện**, `C24`), dòng khai báo base/profile/pack.
- Mục 7 (cưỡng chế/hook/skill): chỉ đề xuất khi có tín hiệu; ghi luật nào rút thành check trong `CONSTRAINTS.md` được.

## 2. Trực quan hoá Định hướng & Chia bộ Spec theo Capability Map (**Trình bày định hướng bằng hình**, `C28` — mục 5 của đề xuất)

Người dùng rất dễ "gật đầu mù" (*rubber-stamp*) trước một bảng chữ dài rồi sau đó phát hiện AI hiểu trật hướng sản phẩm. Trước khi liệt kê danh sách spec, bắt buộc trực quan hoá định hướng theo `C28` (gốc ý tưởng: skill tham khảo nội bộ `brainstorming`, `idea-refine`, `archify`):

1. **Scope Radar — bảng 3 cột phạm vi (`🟢 Làm ngay / 🟡 Đợt kế / 🔴 Không làm`):** Đặt bảng/khối 3 cột ngay đầu mục định hướng để người dùng thấy rõ ranh giới MVP, phần hoãn sang đợt sau và phần loại bỏ hoàn toàn.
2. **Luồng tương tác tổng thể & thẻ phương án trực quan (khi hướng phát triển còn mở):**
   - Vẽ **1 sơ đồ Mermaid** (User Journey / System Flow) thể hiện đường đi của tác nhân chính từ đầu vào đến kết quả.
   - Nếu bài toán có `≥ 2` hướng tiếp cận sản phẩm/kiến trúc khả dĩ, trình bày **2–3 thẻ phương án trực quan (A / B)** kèm phác thảo **Snapshot I/O cụ thể** (ASCII UI wireframe, mẫu lệnh CLI, hoặc JSON payload) + bảng đánh đổi để người dùng nhìn thấy và chọn hướng trước khi đi vào chi tiết.
3. **Chia khu vực độc lập theo miền năng lực:**
   - Liệt kê thực thể và năng lực miền (người dùng, đơn, vai trò, kho, thông báo…); gom thành khu vực kiểm thử độc lập trả lời *"ai dùng tính năng này để làm gì"*.
   - Tách riêng spec **phương tiện** (`ARCH`, `REPO`, `API`, `NFR`) chỉ khi dự án đủ lớn.
4. **Xác định chiều phụ thuộc một chiều (`Depends on`) & Thứ tự xây dựng (`Build Order`):**
   - Mỗi dòng bảng: `SPEC-<TÊN> | Trách nhiệm khu vực | Phụ thuộc vào (Depends on) | Trạng thái dự kiến (Draft/As-built) | Nguồn yêu cầu`.
   - Mũi tên phụ thuộc chỉ đi một chiều, **cấm vòng lặp**. Không có số REQ tối thiểu: chỉ viết chi tiết spec sắp làm, khu vực sau giữ tên/mục tiêu/phụ thuộc. Duyệt Capability Map chưa cấp quyền triển khai (**Quyền thực thi theo đợt**, `C30`).
5. **REQ kế thừa từ Pack (`PK-*`):** Nếu dự án bật pack (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`), ghi REQ kế thừa bằng bảng kèm giá trị tham số `{…}` cụ thể (xem `base-kit.md` §7.2).

## 3. Câu hỏi làm rõ theo `HYPOTHESIS + Frontier + GUESS` (mục 10 — giả thuyết kèm bằng chứng → chỉ hỏi điều người dùng quyết được → kèm đề xuất của AI)

Rút từ mọi `[CẦN LÀM RÕ]` phát hiện được khi điền đề xuất. Áp dụng kỷ luật phỏng vấn từ `interview-me` và `grilling`:

1. **Nêu giả thuyết & Cơ sở (`HYPOTHESIS + EVIDENCE` — **Nguồn & giới hạn hiểu biết**, `C31`):** Tóm tắt mục tiêu/ràng buộc; mỗi khẳng định gắn 1 trong 4 nhãn nguồn (glossary); dẫn lời người dùng, `path:line` hoặc nguồn chính thức, ghi rõ khoảng trống. Không tự chấm phần trăm độ tin cậy.
2. **Chỉ hỏi câu thuộc Frontier (kết quả/đánh đổi mà chỉ người dùng quyết được):** Tối đa 3 câu về hành vi/phạm vi/chi phí mà người dùng quyết được; câu phụ thuộc đáp án trước để lượt sau. Dùng ví dụ đầu vào → kết quả thay cho thuật ngữ chuyên môn.
3. **Đính kèm đề xuất (`➡️ GUESS`):** Nêu kết quả quan sát được, đánh đổi và phần chưa chứng minh. Đồng ý hành vi không xác nhận mọi khẳng định kỹ thuật hay cấp quyền chạy toàn bộ roadmap.
4. **Bóc tách từ khoá chung chung & Không nhận uỷ quyền mơ hồ:**
   - Nếu người dùng trả lời bằng từ khoá chung chung (*"cần scalable, clean, hiện đại"*), hỏi thẳng ngưỡng cụ thể hoặc *"Nếu không phải giải trình với ai, bạn thực sự cần điều gì chạy được trước?"*.
   - *"Tuỳ bạn"* có thể uỷ quyền chi tiết kỹ thuật dễ đảo ngược trong phạm vi đã giao: ưu tiên pattern/dependency sẵn có và ghi cơ sở. Với dữ liệu, phân quyền, tiền hoặc cam kết nghiệp vụ, nêu hệ quả dễ hiểu; AI tự nghiên cứu/thử nghiệm được phép. Nếu vẫn thiếu chuyên môn, ghi cần người có chuyên môn kiểm tra và chặn phần phụ thuộc, không ép người dùng đoán A/B.
5. Đáp án đã chốt → `D-xx` hoặc "Làm rõ" của spec. Khuyến nghị chưa được chứng minh → `P-xx`, không tự biến thành sự thật hay REQ đã duyệt.

## 4. Kế hoạch thử docs (mục 8) & Cố ý không làm (mục 9)

- Chọn sẵn 2–3 task mẫu (Profile S: 2; M/L: 3) sẽ giao cho subagent [`doc-tester`](../../agents/doc-tester.md) ở Cổng 3: 1 task thường gặp, 1 task chạm ranh giới "Hỏi trước", 1 task mơ hồ cố ý.
- Ghi rõ thứ đề xuất **bỏ qua** và lý do (mục 9) để người duyệt biết là đã cân nhắc, không quên.

## Kiểm tra trước khi xong

- [ ] Chưa file docs nào trong repo được tạo/sửa.
- [ ] Mọi thành phần mức 1–2 và Pack được chọn đều có tín hiệu đi kèm.
- [ ] Có **Scope Radar (`🟢 Làm ngay / 🟡 Đợt kế / 🔴 Không làm`)**, sơ đồ luồng Mermaid, và **thẻ phương án trực quan + Snapshot I/O** khi hướng phát triển còn mở (`C28`).
- [ ] Bảng chia bộ spec có cột `Depends on` một chiều (không vòng lặp) + `Build Order` + nguồn yêu cầu truy được.
- [ ] Có bản đọc ngắn: hành vi đầu tiên, ví dụ nghiệm thu, ngoài phạm vi, điều chưa biết; chỉ chi tiết hoá phần sắp làm (`C30`, `C31`).
- [ ] `HYPOTHESIS + EVIDENCE` chỉ rõ nguồn/khoảng trống, ≤ 3 câu người dùng quyết được; phần kỹ thuật có cách kiểm chứng và người chịu trách nhiệm.
