# Core Laws - Đơn giản hóa cho dự án nhỏ

Kế thừa từ `writing-spec-for-ai/references/base-kit.md`, giữ lại 19 luật cốt lõi quan trọng nhất cho dự án nhỏ (`< 50` files, 1–2 người).

## Laws Kế Thừa (Mandatory)

| ID | Luật | Nội dung |
|----|------|----------|
| C01 | Thứ tự nguồn sự thật | `decisions.md` > `specs/` > `conflicts-and-bugs.md` > `AGENTS.md` > code hiện có |
| C03 | Quyền AI theo trạng thái spec | `Draft`: không code. `Ready`: có thể code. `Done`: không sửa trừ khi cập nhật spec |
| C04 | Hệ ID đơn giản | `SPEC-001`, `AC-1`. Tên hàm test chứa `AC-ID`. Commit gắn `[SPEC-001]` |
| C05 | Trạng thái AC | `[ ]` chưa đạt. `[x]` đã đạt kèm bằng chứng test. `[~]` chưa kiểm chứng |
| C11 | Đổi gì sửa file nào | Feature/lệnh mới → `AGENTS.md`. Đổi hành vi → `SPEC-xxx.md`. Có bug/xung đột → `conflicts-and-bugs.md` |
| C12 | Ranh giới 3 tầng | ✅ Luôn: chạy test, DoD. ⚠️ Hỏi: đổi schema, thêm dependency. 🚫 Không: lộ secret, force push |
| C13 | Định nghĩa Xong (DoD) | Test xanh + bảng bằng chứng AC (`C29`) + cập nhật docs |
| C14 | Quy ước commit | `type(scope): mô tả [SPEC-001]` |
| C15 | Ba luật xử lý lỗi | Không nuốt lỗi. Lỗi nội bộ không trả thẳng ra client. Tác vụ phụ bỏ qua lỗi phải ghi log |
| C16 | Secret & cấu hình | `.env.example` đủ khoá, `.env` nằm trong `.gitignore`. Không commit file quyền cá nhân của agent |
| C18 | Sổ tay lỗi & xung đột | Mọi bug, lệch hợp đồng (enum/API/DB/port), hotfix/revert ghi vào `docs/conflicts-and-bugs.md` kèm SHA và cách chặn |
| C21 | Đặt file đúng chỗ | `AGENTS.md` ở gốc repo. Specs ở `docs/specs/`. Decisions ở `docs/decisions.md` |
| C22 | Thử docs trước khi code | Chạy thử 1–2 task mẫu để kiểm chứng docs trước khi code hàng loạt |
| C23 | Không hạ chuẩn âm thầm | Không tự ý thêm `@ts-ignore`, `eslint-disable`, hay xoá assert để ép test xanh |
| C24 | Con trỏ có điều kiện | Viết theo cấu trúc *"Khi chạm X → đọc Y"* ở đầu câu trong `AGENTS.md` |
| C25 | Dẫn nguồn chính thống | Tra cứu tài liệu chính thức của framework/library, không đoán API |
| C29 | Bằng chứng test hiển thị | Xuất bảng `AC / Input / Output / Mock` khi báo cáo test pass |
| C30 | Quyền thực thi & Hỏi khi mơ hồ | Mỗi lượt viết 1 file docs rồi dừng chờ duyệt; gặp yêu cầu mơ hồ phải hỏi, không tự bịa |

## Laws Đơn Giản Hóa Hoặc Chỉ Bật Khi Lên Phase 2/3 (`writing-spec-for-ai`)

| ID | Luật | Cách xử lý ở bản Simple (`< 50` files) |
|----|------|----------------------------------------|
| C02 | Ba cổng duyệt | Đơn giản hóa thành duyệt trực tiếp sau từng bước (3 bước) |
| C06 | Mục bắt buộc của spec | Rút gọn các mục nâng cao trong `templates/SPEC.simple.md` |
| C09 | Đổi spec đã chạy | Cập nhật trực tiếp vào `SPEC-xxx.md` trước khi sửa code |
| C10 | Ngoại lệ hotfix | Nếu sửa gấp, cập nhật bù `SPEC-xxx.md` và `conflicts-and-bugs.md` trong 1 ngày |
| C17 | Bộ nhớ phiên (`progress.md`) | Tùy chọn ở Phase 1; bắt buộc từ Phase 2 (`>= 50` files) hoặc phiên làm việc dài |
| C19 | Kiểm tác dụng lệnh | Giữ nguyên: mọi lệnh ghi trong `AGENTS.md` phải chạy được thật |
| C20 | Đổi stack là thay đổi lớn | Giữ nguyên: phải ghi vào `docs/decisions.md` (`D-xx`) |
| C26 | Phản biện chéo model | Bỏ ở Phase 1; bật khi nâng cấp lên `writing-spec-for-ai` (Phase 2/3) |
| C27 | Đánh dấu giới hạn | Giữ nguyên: ghi rõ giới hạn đã biết |
| C28 | Trình bày bằng hình | Khuyến khích dùng bảng Markdown và sơ đồ ASCII/Mermaid ngắn gọn |
| C31 | Nguồn & thẻ giải thích | Đơn giản hóa: chỉ cần nêu rõ giả định khi hỏi user |

## Nguồn Kế Thừa

- Kế thừa từ: `writing-spec-for-ai/references/base-kit.md` (31 luật đầy đủ `C01–C31`)
- Hướng dẫn mở rộng & đánh giá Spec: `references/scaling-and-evaluation.md`
