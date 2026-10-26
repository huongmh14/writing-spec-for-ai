# Đặc tả <tên dự án>

Nguồn sự thật về yêu cầu. Quyết định ở `../decisions.md`, thuật ngữ ở `../glossary.md`, tiến độ ở `../progress.md` (không ghi nhật ký ở file này).

## Quy ước

- ID spec `SPEC-<KHU-VỰC>`; yêu cầu `<KHU-VỰC>-R<số>`; nghiệm thu `<KHU-VỰC>-AC<số>`. Không đánh số lại; bỏ thì ghi deprecated.
- Mức: **MUST**, **SHOULD** (lệch phải ghi lý do), **MAY**. Giai đoạn ghi kèm: `MUST (GĐ2)`.
- AC *Cho / Khi / Thì*, tên test chứa AC-ID. `[x]` có lệnh/kết quả làm bằng chứng, có CI thì trong chính PR; `[~]` chưa kiểm chứng, kèm lý do + cách đóng.
- Trạng thái: `Draft` → `Ready` (người dùng duyệt yêu cầu, không còn câu hỏi chặn) → `In progress` (có đợt thực thi được giao) → `Done` (mọi AC của spec `[x]` có bằng chứng, chuyển trong PR cuối). `[~]` là chưa kiểm chứng, chưa đủ `Done`. Code có sẵn chưa spec: `As-built`.
- Spec `Ready`/`Done` cần đổi: qua `../changes/`. Phần lớn mới: spec con.
- Spec mới dùng `_template.md`; thiết kế dùng `_design-template.md`.

## Quyền của AI theo trạng thái spec

| Trạng thái | AI được làm | AI không được làm |
|---|---|---|
| `Draft` | Đọc, nêu chỗ thiếu, nghiên cứu, đề xuất hành vi và AC | **Viết code triển khai**; biến đề xuất chưa kiểm chứng thành yêu cầu đã chốt |
| `Ready` | Lập plan (`plan-tasks`), mô tả migration/test dự kiến | **Tự bắt đầu code, test triển khai hoặc migration** chỉ vì spec Ready; đổi yêu cầu |
| `In progress` | Code + test **trong đợt được giao**, đánh `[x]` AC khi có bằng chứng, báo blocker | Lấy task/spec tiếp theo ngoài đợt; thêm chức năng "nhân tiện" |
| `Done` | Phân tích lỗi; sửa đúng hành vi đã chốt khi có đợt sửa lỗi được giao | Tự bắt đầu sửa; đổi hành vi khi chưa có `../changes/CHG-xx` được duyệt |
| `As-built` | Ghi bằng chứng, nêu hành vi đáng ngờ vào câu hỏi mở | Coi code hiện có là chuẩn; "sửa cho hợp lý" |

- **`Ready` là duyệt yêu cầu, không phải quyền thực thi (`C30`).** Một đợt hiện tại ở `../progress.md` ghi chỉ dẫn thật của người dùng, SPEC/task/AC, vùng file, phần loại trừ và điều kiện dừng; AI không tự cấp quyền bằng cách sửa block này.
- Mặc định khi chưa nêu ranh giới đợt: **1 SPEC + 1 task**; làm → kiểm → báo cáo → dừng. Yêu cầu rõ toàn bộ spec/batch hữu hạn được thực hiện đủ mà không hỏi lại từng task; ghi chính xác phạm vi ấy. Plan, Frontier, Build Order và subagent không mở rộng quyền.
- Chỉ dẫn hiện hành của người dùng được ưu tiên; đã duyệt rõ thì không hỏi lại. Yêu cầu triển khai spec `Draft` chưa chốt hành vi: nêu phần chặn và chốt kết quả cần đạt trước.
- Code không theo được spec: dừng phần phụ thuộc, nêu chỗ lệch và đề xuất sửa; phần độc lập đã được giao vẫn tiếp tục được.
- **Hotfix** được giao vẫn có đợt và điểm dừng như trên; được sửa code trước spec, nhưng cập nhật spec trong ≤ 1 ngày làm việc; trước đó ghi nợ vào `../progress.md` (`Còn dở: nợ spec <SPEC-X>`).
- Còn `[~]` thì spec giữ `In progress`; chỉ loại AC khỏi phạm vi khi người dùng chốt thay đổi qua `../changes/`.

## Tài liệu phải sửa theo loại thay đổi

Sửa trong **cùng PR** với code.

| Loại thay đổi | File phải sửa |
|---|---|
| Feature mới | spec mới + dòng trong bảng Danh mục |
| Đổi hành vi spec `Ready`/`Done` | `../changes/CHG-xx` → spec |
| Contract công khai (API, mã lỗi, payload, CLI) | spec + contract máy đọc + `../reference/error-codes.md` nếu đổi mã |
| Schema dữ liệu | spec + migration + `../upgrade/<ver>.md` (nếu có dự án phía dưới) |
| Biến môi trường / cấu hình | `../reference/config.md` + `.env.example` |
| Breaking change | `../changelog/<ver>.md` |
| Quyết định kỹ thuật | `../decisions.md` (+ REQ bị ảnh hưởng) |
| Khuôn mẫu code / quy trình | `AGENTS.md` (hoặc `CONSTRAINTS.md` nếu là ngưỡng chất lượng) |
| **Đổi stack / công cụ build** | Lệnh trong `AGENTS.md` + CI + quy ước code + skill dự án — một change, không tách PR |

## Danh mục & Bản đồ Năng lực (Capability Map)

Chiều phụ thuộc chỉ đi một chiều (không có vòng lặp). Nếu 2 spec phụ thuộc chéo nhau, gộp thành 1 hoặc tách phần chung ra spec nền.

| ID | File | Nội dung | Phụ thuộc vào (`Depends on`) | Giai đoạn | Trạng thái |
|---|---|---|---|---|---|
| SPEC-ARCH | [00-architecture.md](00-architecture.md) | Kiến trúc, nguyên tắc | — | 1 | Draft |

**Thứ tự xây dựng (Build Order):** `SPEC-ARCH → ...`

## Đối chiếu tài liệu nguồn <!-- khi spec dựng từ PRD/docx -->

| Mục nguồn | Spec / REQ |
|---|---|

**Phần lệch so với nguồn:** <nội dung chốt sau tài liệu nguồn, chỉ có ở spec + decisions>
