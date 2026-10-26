# SPEC-XXX — Tiêu đề

| Thuộc tính | Giá trị |
|---|---|
| Trạng thái | Draft <!-- Draft → Ready → In progress → Done; hoặc As-built --> |
| Giai đoạn | 1 |
| Phụ thuộc | SPEC-… |
| Quyết định liên quan | D-… |
| Thiết kế | <!-- link *-design.md nếu có --> |

## Bản đọc ngắn để duyệt hành vi (`C30`, `C31`)

- **Sau thay đổi, ai làm được gì:** <một kết quả quan sát được>.
- **Ví dụ để tự kiểm:** <đầu vào/thao tác → kết quả mong đợi, trỏ AC-ID>.
- **Chưa làm trong lần đầu:** <các hành vi lân cận bị loại>.
- **Điều chưa biết & hệ quả:** <điều chưa chứng minh, ảnh hưởng, ai/cách kiểm; hoặc Không có>.
- **Phần người dùng chốt:** <hành vi, phạm vi, đánh đổi>; chi tiết kỹ thuật xem nguồn bên dưới.
- **Quyền chạy:** `Ready` chưa cấp quyền code; đợt được giao nằm ở `../progress.md`.

## 1. Mục tiêu

<Vấn đề, cho ai, đo thành công bằng gì.>

## 2. Phạm vi

**Trong phạm vi:**
**Ngoài phạm vi:** <!-- không được rỗng -->

## 3. Luồng tương tác, Snapshot I/O & Kịch bản người dùng (`C28`)

- **US1 (P1)** — Là <vai trò>, tôi muốn <…> để <…>. Kiểm độc lập: <…>. AC: XXX-AC01..AC03.

### Luồng tương tác chính (`Mermaid Flow` — `C28`)

```mermaid
sequenceDiagram
    actor U as Tác nhân
    participant S as Hệ thống
    U->>S: <Hành động / Request đầu vào>
    S-->>U: <Phản hồi / Trạng thái đầu ra>
```

### Phác thảo trực quan Đầu vào / Đầu ra (`Concrete I/O Snapshot` — `C28`)

<!-- Vẽ ASCII UI wireframe (nếu có màn hình), mẫu lệnh + output CLI, hoặc JSON request/response thực tế để lập trình viên nhìn thấy ngay hình hài tính năng. -->
```text
+-------------------------------------------------------------------+
| [Tiêu đề màn hình / Lệnh CLI / Endpoint POST /api/v1/...]         |
| Input:  { ... }                                                   |
| Output: { ... } (Trạng thái UI / DB thay đổi gì)                  |
+-------------------------------------------------------------------+
```

## 4. Yêu cầu

| ID | Mức | Yêu cầu | Nguồn & trạng thái (`C31`) |
|---|---|---|---|
| XXX-R01 | MUST | Khi <sự kiện>, hệ thống MUST <…>. | <lời người dùng/PRD đoạn; đã chốt hay đề xuất> |
| XXX-R02 | MUST | Nếu <điều kiện lỗi>, thì hệ thống MUST <…>. | <repo:test hoặc D-xx; hiện trạng hay yêu cầu> |

<!-- Mẫu EARS: Luôn / Khi <sự kiện> / Trong khi <trạng thái> / Nếu <lỗi> thì / Khi bật <tính năng>. Chỗ chưa rõ: [CẦN LÀM RÕ: …] -->

### Kế thừa từ Domain Pack (`PK-*`) <!-- xoá tiểu mục này nếu spec không kế thừa pack -->

| REQ dự án | Kế thừa từ Pack | Tham số `{…}` điền giá trị / Ghi đè |
|---|---|---|
| XXX-R03 | `PK-API-R01` | `{error-code-doc}` = `docs/reference/error-codes.md` |

## 5. Yêu cầu phi chức năng

| Khía cạnh | Điều kiện kiểm được / `N/A — lý do` / `Chưa biết — P-xx` | Cơ sở & cách kiểm (`C31`) |
|---|---|---|
| Hiệu năng | | |
| Bảo mật (dữ liệu nhạy cảm, quyền, cấm log) | | |
| Giới hạn / rate limit | | |
| Khả dụng / khôi phục | | |
| Quan sát (log, metric, audit) | | |
| i18n | | |
| a11y | | |
| Trạng thái UI (loading / empty / error / forbidden) | | |

<!-- Không lấy số ví dụ làm cam kết. Số đo phải kèm tải/môi trường/ngày; tiêu chuẩn hoặc docs API không chứng minh sản phẩm đạt chuẩn. Draft được ghi Chưa biết, kèm phần bị chặn và cách đóng. -->

## 6. Trường hợp biên

- <câu hỏi biên> → XXX-AC0n | ngoài phạm vi

## 7. Điều kiện nghiệm thu & Ma trận Kiểm thử Minh bạch (`Visible Test Matrix` — `C29`)

| Trạng thái | ý nghĩa |
|---|---|
| `[ ]` | chưa đạt |
| `[x]` | test xanh và có bằng chứng lệnh/kết quả; có CI thì trong PR làm AC đó (`Visible Test Execution Ledger`) |
| `[~]` | chưa kiểm chứng — ghi lý do, người/cách đóng; chặn `Done` |

### Ma trận Kiểm thử Minh bạch (`Visible Test Matrix` — duyệt trước khi code theo `C29`)

| Mã AC | Kịch bản (`Cho / Khi / Thì`) | Đầu vào cụ thể (`Concrete Input`) | Kỳ vọng quan sát được (`Expected Output & Side-Effect`) | Tầng & Độ thật (`0 Mock` hay `Mock thành phần nào`) | Trạng thái |
|---|---|---|---|---|---|
| **XXX-AC01** | Nhánh chính: <…> | `<payload / tham số / thao tác>` | `<HTTP 200 + body / bản ghi DB / trạng thái DOM>` | `integration` — **0 Mock** (DB thật) | `[ ]` |
| **XXX-AC02** | Nhánh lỗi / biên: <…> | `<input lỗi / vượt ngưỡng>` | `<HTTP 4xx + errorCode / không ghi DB>` | `unit` / `integration` — **Mock:** `<nêu rõ hoặc 0 Mock>` | `[ ]` |

## 8. Kiểm tra end-to-end

<Lệnh hoặc kịch bản để agent tự xác nhận toàn bộ spec chạy.>

## 9. Ghi chú thiết kế

<Chỉ ràng buộc kiến trúc. Chi tiết thiết kế ở file design. Không chia việc ở đây — thuộc plan.>

## 10. Hướng dẫn vận hành <!-- tuỳ chọn; dành cho người vận hành, không phải REQ -->

## 11. Làm rõ

<!-- ### Phiên YYYY-MM-DD
- H: … → Đ: … (ghi vào R0n / D-xx) -->

## 12. Câu hỏi mở

<!-- Ghi "Không có" nếu rỗng. Mâu thuẫn với spec khác: ghi ở cả hai spec. -->

| Điều chưa biết / đề xuất | Nguồn đã kiểm | Ảnh hưởng / AC bị chặn | Cách xác minh & người phụ trách |
|---|---|---|---|
| <P-xx hoặc câu hỏi> | <bằng chứng hoặc Chưa có> | <phần phụ thuộc; không chặn phần độc lập> | <nghiên cứu/thử nghiệm được phép/chuyên gia> |
