# Spec Evaluation & Health Check Guide

Dùng tài liệu này để:
1. **Đánh giá sau mỗi task (Per-Task Checklist):** Kiểm tra xem Spec và AI có phối hợp hiệu quả không.
2. **Kiểm tra sức khỏe định kỳ (Monthly Health Check & Quick Test):** Nhận biết dự án đang đi đúng hướng hay cần điều chỉnh/nâng cấp.

---

## 1. Quick Test (5 Câu Tự Đánh Giá Trong 1 Phút)

Trả lời nhanh 5 câu hỏi **Có / Không**:

1. **Khi gặp yêu cầu mơ hồ hoặc thiếu dữ kiện, AI có dừng lại hỏi (hoặc nêu giả định chờ duyệt `C30`) thay vì tự đoán/bịa code không?**
   - `Có`  **Good** (AI tôn trọng giới hạn hiểu biết, không bịa requirement)
   - `Không` (AI tự bịa)  **Bad** (Cần kiểm tra lại `AGENTS.md` mục không đoán thay dữ kiện)
2. **Code và test do AI viết có bám sát tiêu chí nghiệm thu (`AC-x`) trong Spec không?**
   - `Có`  **Good**
   - `Không`  **Bad** (Spec không được dùng hoặc `AC` viết mơ hồ, không kiểm thử được)
3. **Khi code thay đổi hành vi hoặc có hotfix, Spec và `docs/conflicts-and-bugs.md` có được cập nhật đi kèm không?**
   - `Có`  **Good**
   - `Không`  **Bad** (Spec bị lệch code hiện tại — vi phạm `C10`, `C11`, `C18`)
4. **Team có review Spec / Plan trước khi cho AI code hàng loạt không?**
   - `Có`  **Good**
   - `Không`  **Bad** (Quy trình duyệt không được tuân thủ hoặc đang quá nặng nề)
5. **Thời gian bắt đầu phiên làm việc mới (hoặc onboarding người mới) có nhanh hơn rõ rệt không?**
   - `Có`  **Good**
   - `Không`  **Bad** (`AGENTS.md` và `docs/progress.md` chưa truyền tải đủ ngữ cảnh cốt lõi)

**Kết quả Quick Test:**
- **`4–5/5` câu "Có":** Hệ thống Spec hiệu quả, AI làm việc đúng chuẩn.
- **`3/5` câu "Có":** Đang đi đúng hướng, cần chỉnh sửa các mục trả lời "Không".
- **`< 3/5` câu "Có":** Cần điều chỉnh lại Spec (rút gọn nếu quá nặng, hoặc làm rõ `AC` nếu quá sơ sài).

---

## 2. Dấu Hiệu Nhận Biết (Indicators)

### 2.1 Dấu Hiệu Đi Đúng Hướng (Positive Signals)

- [x] **Spec đã chuẩn:**
  - Có `AGENTS.md` với lệnh `build` / `test` / `dev` chạy được thật (`C19`).
  - Các spec có ID (`SPEC-001`), yêu cầu (`REQ-001`) và tiêu chí nghiệm thu (`AC-1`) có kịch bản `GIVEN/WHEN/THEN` gắn với test (`C04`).
  - Có trạng thái vòng đời rõ ràng (`Draft`  `Ready`  `In progress`  `Done`).
  - Quyết định được ghi vào `docs/decisions.md` (`D-xx`), lỗi/xung đột lịch sử được ghi vào `docs/conflicts-and-bugs.md` (`C18`).
- [x] **AI làm việc hiệu quả:**
  - AI đọc spec trước khi code (`C01`), không đoán mò.
  - AI hỏi khi mơ hồ (`C30`), không bịa requirement.
  - AI xuất bảng bằng chứng test (`input / output / mock`, `C29`) khi báo hoàn thành.
- [x] **Team đồng thuận & Metrics cải thiện:**
  - Review spec trước khi code; review code đối chiếu spec (`code-review`).
  - Spec thay đổi trước khi sửa code (`C09`); hotfix thì cập nhật spec trong 1 ngày (`C10`).
  - Bug rate giảm, thời gian onboarding giảm, ít comment bắt lỗi logic khi review PR.

### 2.2 Dấu Hiệu Cảnh Báo (Negative Signals & Cách Chữa)

| Nhóm vấn đề | Biểu hiện | Hành động khắc phục |
|---|---|---|
| [] **Spec rỗng / lỗi thời** | Spec chỉ là placeholder; không được cập nhật; AI bỏ qua spec; spec lệch code hiện tại. | Chạy `scripts/validate.ps1`; bắt buộc cập nhật spec trong cùng PR khi đổi hành vi (`C11`). |
| [] **Spec quá nặng** | Spec quá dài không ai đọc; đi vào chi tiết cài đặt (micro-management); viết spec lâu hơn viết code. | Chỉ giữ hành vi quan sát được (`WHAT`, không phải `HOW`); chuyển quy tắc lặp lại vào `CONSTRAINTS.md` / linter. |
| [] **Spec không được dùng** | Code mới không có `SPEC-xxx`; AI không đọc spec; review PR không kiểm tra `AC-x`. | Thêm con trỏ điều kiện ở đầu câu trong `AGENTS.md` (`C24`: *"Khi chạm X  đọc Y"*). |
| [] **Process quá formal** | 3 cổng formal gây nghẽn ở dự án nhỏ; team tìm cách lách quy trình; adoption thấp. | Nếu repo `< 50` files  hạ xuống `writing-spec-simple` hoặc `Profile S` (duyệt nhanh 3 bước). |

---

## 3. Bảng Health Check Định Kỳ (1 Tháng / Lần)

| Metric | Good | Warning | Bad | Cách đo lường |
|---|---|---|---|---|
| **Spec coverage** | `> 80%` features có spec | `50–80%` | `< 50%` | Số tính năng có `SPEC-xxx` / tổng số tính năng triển khai. |
| **Spec-to-code sync** | `< 5%` lệch | `5–20%` lệch | `> 20%` lệch | Kết quả chạy `scripts/validate.ps1` và tỷ lệ `AC [x]` khớp test thực tế. |
| **AI spec adherence** | `> 90%` code theo spec | `70–90%` | `< 70%` | Tỷ lệ task AI hoàn thành vượt qua `code-review` (trục Spec) + có bằng chứng `C29`. |
| **Bug rate** | Giảm so với kỳ trước | Không đổi | Tăng | Số bug/xung đột mới ghi vào `docs/conflicts-and-bugs.md` (`C18`). |
| **Onboarding time** | Giảm `> 50%` | Giảm `20–50%` | Không giảm | Thời gian để dev mới hoặc phiên AI mới nắm được kiến trúc và xong task đầu tiên. |
| **Team satisfaction** | `> 4/5` | `3–4/5` | `< 3/5` | Điểm đánh giá nội bộ của team về tính hữu dụng của bộ docs. |
| **Process friction** | Low | Medium | High | Thời gian trung bình để viết và duyệt 1 spec mới. |

---

## 4. Kế Hoạch Hành Động Định Kỳ (Action Plan)

- **Hàng tuần (Weekly):**
  - [] Spec mới hoặc thay đổi trong tuần có được cập nhật trạng thái `AC` và `docs/conflicts-and-bugs.md` không?
  - [] AI có đọc spec trước khi code và xuất bằng chứng test (`C29`) không?
  - [] Có bug nào phát sinh do spec thiếu hoặc viết sai không? (Nếu có  bổ sung `AC` ngay).
- **Hàng tháng (Monthly):**
  - [] Chạy bảng **Health Check List** (Mục 3) và `scripts/skill-health-check.sh`.
  - [] Kiểm tra việc điều hướng của `auto-guide` (đề xuất đúng skill theo quy mô dự án chưa?).
  - [] Thu thập phản hồi từ team để cắt bỏ phần văn xuôi thừa trong docs.
- **Hàng quý (Quarterly):**
  - [] Đánh giá quy mô dự án: Đã cần nâng cấp từ `writing-spec-simple`  `writing-spec-for-ai` (Profile M/L) chưa?
  - [] Đánh giá có cần bật thêm Domain Pack (`PK-API`, `PK-DB`, `PK-AUTH`, `PK-OBS`, `PK-SEC`) không?
  - [] Đánh giá có cần tạo project-skill riêng hoặc verify harness (`generate-verify-harness`) cho các luồng lặp lại `≥ 2` lần không?

---

## 5. Checklist Đánh Giá Chi Tiết Sau Mỗi Task (Per-Task Evaluation)

### 5.1 Spec Quality
| Metric | Yes/No | Notes |
|---|---|---|
| Có `AGENTS.md` với lệnh build/test/dev chạy được thật (`C19`)? | | |
| Spec có mã `SPEC-xxx`, `REQ-xxx` và trạng thái (`Draft`/`Ready`/`In progress`/`Done`)? | | |
| Mỗi `AC-x` có kịch bản `GIVEN/WHEN/THEN` rõ ràng và gắn với test (`C04`)? | | |

### 5.2 AI Adherence & Test Evidence
| Metric | Yes/No | Notes |
|---|---|---|
| AI đọc `decisions.md`, `SPEC-xxx`, `conflicts-and-bugs.md` trước khi code (`C01`)? | | |
| AI hỏi khi mơ hồ, không tự bịa requirement (`C30`)? | | |
| Có bảng bằng chứng test (`input / output / mock`, `C29`) thay vì chỉ báo `"All tests passed"`? | | |
| Đã cập nhật `docs/progress.md` (`C17`) và `docs/conflicts-and-bugs.md` (`C18`, nếu có lỗi)? | | |
| Commit tuân thủ định dạng `type(scope): mô tả [SPEC-xxx]` (`C14`)? | | |
