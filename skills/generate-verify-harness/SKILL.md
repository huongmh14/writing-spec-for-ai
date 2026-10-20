---
name: generate-verify-harness
description: Dùng ở Bước 7.5–8 khi dự án bước sang giai đoạn code/nghiệm thu hoặc khi người dùng nói "tạo skill verify", "tạo bộ kiểm chứng tự động cho app". Sinh skill kiểm chứng thực tế cấp dự án (.agents/skills/verify-<app>/SKILL.md) để AI agent tự khởi chạy, kiểm tra sức khoẻ, điều khiển ứng dụng và thu bằng chứng nghiệm thu.
---

# Generate verify harness — sinh Skill Kiểm chứng Thực tế cho Dự án

Đầu vào: repo dự án + `AGENTS.md` + `docs/specs/`.
Đầu ra:
1. `.agents/skills/verify-<tên-app>/SKILL.md` (và đồng bộ sang `.claude/skills/` hoặc `.cursor/skills/` nếu dự án dùng).
2. Bản đồ tính năng kiểm chứng `.agents/skills/verify-<tên-app>/features/README.md` + 3–5 luồng chính.

> Nguồn kế thừa: `pstack/create-verification-skill`, `playwright`, luật Core `C19` (kiểm tác dụng thật, không chỉ exit code).

## 1. Khảo sát cơ chế điều khiển từ repo (Không hỏi điều đọc được từ code)

Trước khi viết skill, tự đọc repo để xác định 5 yếu tố:
- **Bề mặt tương tác (Surface):** Web UI, HTTP API, CLI/TUI, Worker/Daemon, hay Desktop/Electron?
- **Cách khởi chạy (Launch):** Lệnh khởi động từ trạng thái sạch (gồm cả migration + seed nếu có), cổng mạng, biến môi trường, và **dấu hiệu thật sự sẵn sàng** (log line cụ thể hoặc health endpoint trả `200`, không chỉ là tiến trình vừa bật).
- **Công cụ điều khiển (Drive):** Ưu tiên harness có sẵn trong repo (Playwright, test runner, script CLI, `curl`); nếu chưa có mới chọn công cụ chuẩn (Playwright/CDP cho Web, PTY/subshell cô lập cho CLI, HTTP client cho API).
- **Bằng chứng thu thập (Evidence):** Ảnh chụp màn hình, bản ghi terminal, HTTP response body + status, dòng log có `requestId`, và trạng thái dữ liệu trong DB/file sau thao tác.
- **Cô lập (Isolation):** Hai phiên kiểm chứng có chạy song song được không (port riêng, DB/thư mục tạm riêng)? Nếu không, phải ghi rõ quy tắc kiểm tra khoá để tránh đè lên phiên của lập trình viên.

## 2. Cấu trúc bắt buộc của `.agents/skills/verify-<tên-app>/SKILL.md`

Viết cho **agent kế tiếp đọc lúc chưa biết gì về app** (không để lại bất kỳ placeholder `<...>` nào):

1. **Launch:** Lệnh khởi chạy đầy đủ và cách xác nhận hệ thống đã sẵn sàng phục vụ.
2. **Doctor:** Một lệnh chỉ đọc (read-only) chạy trong `< 3 giây` để trả lời *"instance này có đang sống, đúng phiên bản build mới nhất, và sẵn sàng nhận kiểm thử không?"*.
3. **Drive:** Công thức điều khiển bằng selector/lệnh thật của dự án (ưu tiên ARIA role/label, route path, CLI flags ổn định).
4. **Evidence & Visible Test Ledger (`C19`, `C29`):** Tiêu chuẩn bằng chứng nghiệm thu cho các `AC-ID`:
   - Phải đi qua đường người dùng thật (không gọi hàm nội bộ tắt ngang).
   - Kiểm tra cả **phản hồi bề mặt** lẫn **tác dụng phụ thực tế** (bản ghi DB, file sinh ra, message trong queue — luật `C19`).
   - **In Bảng Bằng chứng Chạy Test (`Visible Test Execution Ledger` — `C29`):** Kết thúc mỗi lượt verify, bắt buộc in ra bảng tóm tắt cho lập trình viên thấy rõ: `AC-ID | Kịch bản đã chạy | Input đã bơm | Output & Tác dụng phụ thực tế | Độ thật (0 Mock hay Mock thành phần nào) | Kết quả & Thời gian`, kèm đường dẫn ảnh chụp màn hình / trace log.
   - Lưu bằng chứng vào thư mục cố định để không bị xoá mất khi dọn dẹp.
5. **Cleanup:** Lệnh tắt đúng tiến trình do phiên kiểm chứng bật lên (theo PID/container tên riêng, **cấm `killall` theo tên chung**), xoá dữ liệu rác nhưng giữ nguyên thư mục chứa bằng chứng (`Evidence`).

## 3. Khởi tạo Bản đồ tính năng (`features/README.md`)

Tạo danh mục 3–5 luồng cốt lõi tương ứng với các `SPEC-<TÊN>` quan trọng nhất. Mỗi luồng ghi ngắn gọn 4 mục:
- `Các hành vi con (AC-ID liên quan)`
- `Cách đi tới luồng (góc nhìn người dùng)`
- `Cách điều khiển bằng <harness>`
- `Gotchas (bẫy đã biết + ngày kiểm lần cuối theo C18)`

## 4. Chạy thử thực tế trước khi bàn giao (Prove It Works)

Bắt buộc tự thực thi đúng hướng dẫn vừa viết 1 vòng từ đầu tới cuối cho ít nhất 1 luồng: **Launch → Doctor → Drive → Capture Evidence → Cleanup**, rồi xác nhận file bằng chứng vẫn còn nguyên sau bước Cleanup. Nếu bước nào vấp, sửa ngay vào skill rồi chạy lại.

## Kiểm tra trước khi xong

- [ ] `.agents/skills/verify-<tên-app>/SKILL.md` có YAML frontmatter (`name`, `description`) hợp lệ và không còn placeholder.
- [ ] Có đủ 5 mục: `Launch`, `Doctor`, `Drive`, `Evidence`, `Cleanup`.
- [ ] Đã chạy thử thật ít nhất 1 luồng end-to-end và thu được bằng chứng sống sót sau bước `Cleanup`.
