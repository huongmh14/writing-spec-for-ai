# SPEC-XXX — Tiêu đề

| Thuộc tính | Giá trị |
|---|---|
| Trạng thái | Draft <!-- Draft → Ready → In progress → Done; hoặc As-built --> |
| Giai đoạn | 1 |
| Phụ thuộc | SPEC-… |
| Quyết định liên quan | D-… |
| Thiết kế | <!-- link *-design.md nếu có --> |

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

| ID | Mức | Yêu cầu |
|---|---|---|
| XXX-R01 | MUST | Khi <sự kiện>, hệ thống MUST <…>. |
| XXX-R02 | MUST (GĐ2) | Nếu <điều kiện lỗi>, thì hệ thống MUST <…>. |

<!-- Mẫu EARS: Luôn / Khi <sự kiện> / Trong khi <trạng thái> / Nếu <lỗi> thì / Khi bật <tính năng>. Chỗ chưa rõ: [CẦN LÀM RÕ: …] -->

### Kế thừa từ Domain Pack (`PK-*`) <!-- xoá tiểu mục này nếu spec không kế thừa pack -->

| REQ dự án | Kế thừa từ Pack | Tham số `{…}` điền giá trị / Ghi đè |
|---|---|---|
| XXX-R03 | `PK-API-R01` | `{error-code-doc}` = `docs/reference/error-codes.md` |

## 5. Yêu cầu phi chức năng

| Khía cạnh | Yêu cầu (số liệu) hoặc `N/A — lý do` |
|---|---|
| Hiệu năng | |
| Bảo mật (dữ liệu nhạy cảm, quyền, cấm log) | |
| Giới hạn / rate limit | |
| Khả dụng / khôi phục | |
| Quan sát (log, metric, audit) | |
| i18n | |
| a11y | |
| Trạng thái UI (loading / empty / error / forbidden) | |

## 6. Trường hợp biên

- <câu hỏi biên> → XXX-AC0n | ngoài phạm vi

## 7. Điều kiện nghiệm thu & Ma trận Kiểm thử Minh bạch (`Visible Test Matrix` — `C29`)

| Trạng thái | ý nghĩa |
|---|---|
| `[ ]` | chưa đạt |
| `[x]` | test xanh trong CI của PR làm AC đó (đã có bằng chứng trong `Visible Test Execution Ledger`) |
| `[~]` | cần môi trường thật — ghi lý do và cách đóng |

### Ma trận Kiểm thử Minh bạch (`Visible Test Matrix` — duyệt trước khi code theo `C29`)

| Mã AC | Kịch bản (`Cho / Khi / Thì`) | Đầu vào cụ thể (`Concrete Input`) | Kỳ vọng quan sát được (`Expected Output & Side-Effect`) | Tầng & Độ thật (`0 Mock` hay `Mock thành phần nào`) | Trạng thái |
|---|---|---|---|---|---|
| **XXX-AC01** | Nhánh chính: <…> | `<payload / tham số / thao tác>` | `<HTTP 200 + body / bản ghi DB / trạng thái DOM>` | `integration` — **0 Mock** (DB thật) | `[ ]` |
| **XXX-AC02** | Nhánh lỗi / biên: <…> | `<input lỗi / vượt ngưỡng>` | `<HTTP 4xx + errorCode / không ghi DB>` | `unit` / `integration` — **Mock:** `<nêu rõ hoặc 0 Mock>` | `[~]` *Lý do:* <…>. *Cách đóng:* <…> |

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
