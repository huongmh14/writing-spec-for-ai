---
name: write-spec
description: Dùng ở Bước 5b khi viết spec mới (Draft) hoặc đặc tả hiện trạng code (As-built) sau khi qua Cổng 1, hoặc khi người dùng nói "viết spec", "đặc tả", "SPEC-XXX", "yêu cầu nghiệm thu". Tạo file đặc tả REQ (mẫu EARS), NFR định lượng, trường hợp biên và AC (Cho/Khi/Thì kèm tầng test).
---

# Write spec — viết một spec xây dựng cụ thể (Bước 5, phần spec)

Đầu vào: một khu vực đã có trong đề xuất được duyệt + nguồn yêu cầu (PRD/phỏng vấn/code) + `docs/glossary.md`, `docs/decisions.md`.
Đầu ra: một file `docs/specs/<nn>-<khu-vực>.md` theo `templates/docs/specs/_template.md`, mọi placeholder đã xoá.

Ví dụ chuẩn đạt: [references/examples.md](../../references/examples.md). Nguyên tắc nền: [references/principles.md](../../references/principles.md) §3.

Profile S không có cây docs: dùng `docs/spec.md` hoặc README và block đợt trong `AGENTS.md`; bỏ các lượt đọc file không tồn tại. Giữ cùng luật nguồn, AC, quyền và điểm dừng; không sinh thêm cây docs.

## 0. Chuẩn bị (5 phút, không bỏ)

1. Đọc `docs/specs/README.md` — biết spec nào đã có, tránh đè khu vực.
2. Đọc `docs/glossary.md` — dùng đúng thuật ngữ; thiếu thuật ngữ thì thêm vào glossary **trước** khi viết spec.
3. Đọc `docs/decisions.md` — quyết định nào chạm khu vực này thì chỉ ghi `D-xx` trong spec, không chép lý do.
4. Chốt ID: `SPEC-<TÊN>` + tiền tố REQ/AC `<TÊN>-Rnn`/`<TÊN>-ACnn`. Đã dùng trong đề xuất được duyệt; không đổi ID sau khi viết.
5. **Mỗi lượt một bước con, 5b đúng 1 spec** (**Quyền thực thi theo đợt**, `C30` — Checkpoint 5b): mỗi lượt chỉ viết **ĐÚNG 1 file `SPEC-xx` sắp làm** (kèm cập nhật `docs/specs/README.md` và bản đọc ngắn cho người dùng), rồi **BẮT BUỘC DỪNG LẠI** chờ người dùng review xong mới viết spec tiếp hoặc sang 5c/6. Cấm viết nhiều file `SPEC-xx` trong một lượt. `Ready` xác nhận yêu cầu; quyền chạy code nằm ở đợt thực thi.

## 1. Trực quan hoá luồng & trích yêu cầu từ nguồn (**Trình bày định hướng bằng hình**, `C28`)

- **Vẽ luồng & Snapshot I/O trước khi viết REQ (`C28` — mục 3 của spec):** Vẽ 1 sơ đồ Mermaid (User Journey / State Flow) + 1 **Snapshot I/O cụ thể** (ASCII wireframe màn hình, mẫu lệnh CLI, hoặc JSON request/response thực tế) để lập trình viên nhìn thấy ngay hình hài tính năng thay vì đọc chay bảng REQ.
- **Nguồn là tài liệu/phỏng vấn (greenfield, Draft):** Gạch động từ hành động → REQ ứng viên; điều kiện xấu ("không được", "chỉ khi", "tối đa") → REQ mẫu Lỗi; mục tiêu số → NFR; chỗ không suy ra được → `[CẦN LÀM RÕ: …]` ngay trong dòng REQ, không tự bịa.
- **Nguồn là code (brownfield, As-built — spec mô tả code đã có):** Mỗi hành vi quan sát được từ ngoài (response, hiệu ứng dữ liệu, trạng thái UI) một REQ kèm bằng chứng `file:hàm` hoặc test; hành vi đáng ngờ (không test, nghi bug) → đưa vào **câu hỏi mở**, không chuẩn hoá.

## 2. Viết REQ — mẫu EARS (mẫu câu Luôn / Khi / Trong khi / Nếu của Alistair Mavin)

Mỗi REQ: 1 câu, có ID, có mức (MUST/SHOULD/MAY), kèm giai đoạn nếu không làm ngay (`MUST (GĐ2)`).

| Nguồn gợi ý | Mẫu câu | Ví dụ thật |
|---|---|---|
| Hành vi luôn đúng | `Hệ thống MUST <…>` | RBAC-R01: User không ACTIVE có quyền hiệu lực rỗng |
| Phản ứng sự kiện | `Khi <sự kiện>, hệ thống MUST <…>` | RBAC-R21: Thay đổi thu hẹp vai trò mẫu áp dụng ngay khi sync, tăng `permVersion`, ghi AuditLog |
| Điều kiện trạng thái | `Trong khi <trạng thái>, hệ thống MUST <…>` | RBAC-R01 |
| Nhánh lỗi | `Nếu <điều kiện xấu>, thì hệ thống MUST <kết quả cụ thể: mã HTTP/mã lỗi>` | RBAC-R16: Thiếu quyền ⇒ 403 `AUTH_FORBIDDEN` |
| Tính năng tắt/mở | `Khi bật <tính năng>, hệ thống MUST <…>` | RBAC-R30: scope ORG_TREE khi đơn vị có con |

Quy tắc chặt:
- **Số phải có cơ sở (**Nguồn & giới hạn hiểu biết**, `C31`):** ngưỡng cần nguồn yêu cầu, số đo có điều kiện, hoặc đề xuất ghi rõ chưa chốt. Không biến ví dụ `p95 < 5 ms`/`10 lần/phút` thành cam kết. Chưa biết → câu hỏi mở + cách xác minh, không điền số cho đủ mẫu.
- **Cột nguồn của mỗi REQ/NFR ghi đúng 1 trong 4 nhãn** ([glossary](../../references/glossary.md)): `Người dùng chốt` (ngày/câu nói hoặc mục Làm rõ) · `Đã xác minh` (đúng 1 con trỏ mở được: `path:line` | URL + trích nguyên văn + ngày đọc | lệnh + kết quả thật) · `AI đề xuất` (lý do 1 dòng + hậu quả nếu sai) · `Chưa biết` (cách xác minh + ai + phần bị chặn). Một khẳng định một dòng, không tự chấm %. Code chứng minh hiện trạng, không chứng minh nhu cầu; docs chính thức chứng minh API, không chứng minh NFR sản phẩm.
- **Quyết định kỹ thuật vượt hiểu biết người dùng → Thẻ quyết định kỹ thuật** (mẫu ở `templates/docs/specs/_template.md` §9; design doc dùng cùng khung): Nói đơn giản · Nếu sai thì sao · Tự kiểm trong ≤ 5 phút (trỏ AC-ID) · Nguồn · Không tự kiểm được. Người dùng duyệt dòng Tự kiểm, không duyệt lập luận; vùng bảo mật/thanh toán/pháp lý/dữ liệu cá nhân ghi "cần chuyên gia: <vai trò>".
- Tên mã lỗi, tên trường, tên hàm viết đúng như sẽ xuất hiện trong code/contract. Không viết cách cài đặt (thuộc design), không chia việc (thuộc plan).
- Một REQ một hành vi; REQ ghép 3 hệ quả (vd. R21) chỉ khi các hệ quả luôn xảy ra cùng nhau và cùng được kiểm.

## 3. NFR — đủ 8 dòng, không bỏ dòng

Điền bảng theo template: **giá trị có cơ sở**, `N/A — lý do` nếu thực sự không áp dụng, hoặc `Chưa biết — P-xx + cách xác minh + AC bị chặn` trong Draft. Chưa biết không có nghĩa là N/A; số đo phải kèm môi trường/tải/ngày. Bảo mật/a11y có thể là điều kiện kiểm được, không bắt ép thành số.

| Dòng | Câu hỏi định giá | Ví dụ thật (SPEC-NFR) |
|---|---|---|
| Hiệu năng | Ngưỡng p95/p99 ở đâu, với điều kiện nào (cache nóng, số bản ghi) | guard p95 < 5 ms (cache nóng) |
| Bảo mật | Dữ liệu nhạy cảm gì, cấm log gì, mã hoá gì | redact `Authorization`, `code`, `token` |
| Giới hạn | Rate limit theo IP/user, kích thước payload | 10 lần/phút/user cho chạy báo cáo |
| Khả dụng | Health check gì, failover thế nào | `/health/ready` kiểm DB, Redis, SMTP |
| Quan sát | Log/metric/audit bắt buộc | Metric: tỉ lệ lỗi, độ dài hàng đợi |
| i18n | Ngôn ngữ nào | vi (mặc định), en |
| a11y | Tiêu chuẩn, phạm vi màn | WCAG 2.2 AA cho màn quản trị, hoặc N/A — lý do |
| Trạng thái UI | loading/empty/error/forbidden có bắt buộc render không | mỗi bảng phải có empty + error state |

## 4. Trường hợp biên — sinh từ checklist

Với mỗi REQ dữ liệu, hỏi theo danh sách: rỗng · đúng 1 · đầy · vượt ngưỡng · âm/sai định dạng · quyền hết hạn giữa thao tác · hai người sửa đồng thời · dữ liệu đã bị xoá mềm · ngôn ngữ/kích thước cực đại · dịch vụ phụ tắt (Redis/SMTP). Mỗi biên → một AC, hoặc ghi vào "Ngoài phạm vi". Không để biên nào không có số phận.

## 5. Viết AC & Ma trận Kiểm thử Minh bạch (**Bằng chứng test hiển thị**, `C29` — Cho / Khi / Thì)

Công thức: **Cho** <trạng thái ban đầu với dữ liệu cụ thể>, **khi** <hành động đúng như người/test gọi>, **thì** <kết quả quan sát được: mã HTTP, mã lỗi, dữ liệu, trạng thái DOM>.

- Mỗi REQ ≥ 1 AC; phải có ≥ 1 AC cho nhánh lỗi của khu vực. Tên hàm test chứa `AC-ID` (xem `examples.md` §2, §9).
- **Ma trận Kiểm thử Minh bạch (`C29`, mục 7 của spec)** để người dùng duyệt trước kịch bản test AI sẽ chạy: `AC-ID | Kịch bản | Đầu vào cụ thể | Kỳ vọng quan sát được (Output & tác dụng phụ DB/DOM) | Tầng & độ thật (0 Mock hay Mock thành phần nào)`.
- AI viết cả kỳ vọng lẫn test → test xanh chỉ chứng minh code khớp kỳ vọng của AI, không chứng minh kỳ vọng đúng; người dùng phải duyệt cột Kỳ vọng.
- AC phụ thuộc hạ tầng thật (registry, email) → `[~]` + lý do + người/cách đóng; chưa phải pass và chặn `Done`. Mock chỉ chứng minh ranh giới đã test, không chứng minh dịch vụ thật.
- AC cho lệnh vận hành (`migrate`, `sync`, `seed`, `deploy`) phải kiểm **tác dụng** (bảng tồn tại, số bản ghi, file sinh ra — **Kiểm tác dụng lệnh vận hành**, `C19`), không chỉ exit code 0; kèm AC lỗi (`exit ≠ 0`).

## 6. Đóng gói

- **Kiểm end-to-end** (mục 8): 1–3 lệnh/kịch bản agent tự chạy để xác nhận cả spec — chọn luồng xuyên BE→DB→FE, không lặp lại từng AC.
- **Câu hỏi mở** (mục 12): gom mọi `[CẦN LÀM RÕ]` còn lại; ghi "Không có" nếu rỗng. Mâu thuẫn với spec khác → ghi ở **cả hai** spec.
- **Làm rõ** (mục 11): mỗi đáp án nhận được ghi `### Phiên YYYY-MM-DD — H: … → Đ: … (vào R0n / D-xx)`.
- Trạng thái: `Draft` (greenfield) / `As-built` (brownfield). Chỉ người dùng chuyển `Ready`.
- Unknown chặn REQ/AC đã cam kết phải được kiểm trước `Ready`; AI khác đồng ý không thay bằng chứng. Có thể tách nhánh chưa chốt thành spec con Draft để spec độc lập được duyệt Ready; phần đã cam kết chỉ tách/hoãn qua change-spec được duyệt. Phần ngoài cam kết giữ backlog, không tự thêm vào spec sắp làm.

## 7. Gotchas

- Spec chép lý do quyết định → xoá, chỉ để `D-xx`.
- AC viết "hệ thống hoạt động đúng" → thay bằng mã lỗi/dữ liệu cụ thể.
- Nhiều spec đủ 20 REQ mà NFR bỏ trống → NFR là mục hay bị bỏ nhất; điền trước nếu dễ quên.
- Spec Ready bị nối thêm 10 REQ → dừng, dùng `change-spec`.
- Thuật ngữ đổi tên giữa chừng → đồng bộ glossary + toàn spec trong cùng lần sửa.

## Kiểm tra trước khi trình

- [ ] Có sơ đồ luồng Mermaid và **Snapshot I/O cụ thể** (ASCII wireframe / CLI / JSON mẫu) theo `C28`.
- [ ] Mỗi REQ: 1 câu, có ID + mức, theo 1 mẫu EARS, không tính từ mơ hồ.
- [ ] NFR đủ 8 dòng; mỗi REQ/NFR có 1 trong 4 nhãn nguồn (`C31`), không có số tự bịa; `N/A` không che điều chưa biết; quyết định kỹ thuật vượt hiểu biết người dùng có Thẻ quyết định với dòng Tự kiểm rẻ.
- [ ] Mỗi REQ ≥ 1 AC; có AC lỗi; có AC biên; có **Ma trận Kiểm thử Minh bạch** (`C29`) nêu rõ Input, Output kỳ vọng và độ thật (`0 Mock` hay `Mock gì`).
- [ ] "Ngoài phạm vi" không rỗng; có kiểm end-to-end; câu hỏi mở có mặt (hoặc "Không có").
- [ ] Không còn `[CẦN LÀM RÕ]` nếu người dùng đã chuyển `Ready`; As-built có bằng chứng file/test.
