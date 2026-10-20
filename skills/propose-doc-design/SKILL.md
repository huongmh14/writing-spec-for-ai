---
name: propose-doc-design
description: Lập đề xuất thiết kế bộ tài liệu cho AI agent của một dự án — AGENTS.md, glossary, decisions, danh sách spec theo khu vực, plans, adapters, hook — kèm mức 0/1/2, câu hỏi làm rõ và kế hoạch thử tài liệu; dừng chờ người dùng duyệt (Cổng 1), chưa tạo file nào trong repo. Dùng sau khi khảo sát, hoặc khi người dùng nói "đề xuất docs", "thiết kế tài liệu cho AI", "được duyệt chưa".
---

# Propose doc design — đề xuất thiết kế docs (Bước 3–4 của writing-spec-for-ai)

Đầu vào: kết quả `survey-project` (bảng hiện trạng + mức).
Đầu ra: MỘT file đề xuất theo `templates/doc-design-proposal.md`, lưu ở thư mục artifact của phiên (hoặc `docs/proposals/` nếu người dùng muốn). **Chưa tạo bất kỳ file docs thật nào trong repo.**

→ Gửi đề xuất, dừng, chờ duyệt (Cổng 1). Không duyệt thì sửa đề xuất, không lách sang viết docs.

## 1. Điền đề xuất từ kết quả khảo sát

- Mục 1 (hiện trạng): chép bảng khảo sát, giữ nguyên cột bằng chứng.
- Mục 2 (mức): chỉ giữ thành phần mức 1–2 có tín hiệu.
- Mục 3 (cây file): mỗi file ghi rõ Tạo / Sửa / Di chuyển / Xoá — repo có sẵn docs thì ưu tiên sửa/di chuyển, không tạo bản sao thứ hai.
- Mục 4 (nội dung AGENTS.md): viêt sẵn các giá trị chính — lệnh, 3 tầng ranh giới, DoD, file mẫu để bắt chước.
- Mục 7 (cưỡng chế/hook/skill): chỉ đề xuất khi có tín hiệu; ghi luật nào rút thành check được.

## 2. Chia bộ spec theo khu vực (mục 5 của đề xuất) — phần quan trọng nhất

Cách chia, theo thứ tự:

1. Liệt kê **thực thể và tiện ích miền** từ tài liệu nguồn/khảo sát: người dùng, đơn, vai trò, kho, thông báo, báo cáo…
2. Gom thành 6–12 khu vực, mỗi khu vực trả lời "ai dùng tính năng này để làm gì". Đặt tên theo miền (`RBAC`, `ORDERS`, `NOTIF`), không theo tầng kỹ thuật.
3. Tách riêng các spec **phương tiện** mọi phần cùng phải theo: `ARCH`, `REPO`, `API`, `NFR` — chỉ khi dự án đủ lớn (nhiều module/team).
4. Mỗi khu vực → 1 dòng bảng: `SPEC-<TÊN> | khu vực | trạng thái dự kiến (Draft/As-built) | nguồn yêu cầu (đường dẫn PRD/issue/code)`.
5. Kiểm khối lượng: 1 spec ≈ 10–25 REQ. Khu vực lớn hơn → tách (vd. `AUTH` tách `MFA`); nhỏ hơn 5 REQ → gộp.

Tham chiếu chuẩn: 19 spec của dashboard (examples.md §5). 

## 3. Câu hỏi làm rõ (mục 10)

Rút từ mọi `[CẦN LÀM RÕ]` phát hiện được khi điền đề xuất. Quy tắc:

- Tối đa ~5 câu mỗi lượt; câu ảnh hưởng kiến trúc/phạm vi trước câu chi tiết.
- Mỗi câu kèm **đề xuất** và **hệ quả nếu chọn khác**.
- Đáp án là quyết định → sẽ ghi `D-xx`; là yêu cầu → ghi vào mục "Làm rõ" của spec.

## 4. Kế hoạch thử docs (mục 8)

Chọn sẵn 2–3 task mẫu sẽ dùng ở Cổng 3 (xem `test-docs`): 1 task thường gặp, 1 task chạm ranh giới "Hỏi trước", 1 task mơ hồ cố ý.

## 5. Cố ý không làm (mục 9)

Ghi rõ thứ đề xuất **bỏ qua** và lý do (vd. "chưa có hook vì repo mới, chưa có luật vi phạm 2 lần") — để người duyệt biết là đã cân nhắc, không quên.

## Kiểm tra trước khi xong

- [ ] Chưa file docs nào trong repo được tạo/sửa.
- [ ] Mọi thành phần mức 1–2 có tín hiệu đi kèm.
- [ ] Mỗi spec dự kiến có nguồn yêu cầu truy được.
- [ ] Mục câu hỏi có ≤ 5 câu, câu lớn nhất đứng đầu, mỗi câu có đề xuất.
