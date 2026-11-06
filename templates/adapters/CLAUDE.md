@AGENTS.md

<!-- Claude Code không đọc AGENTS.md mặc định nên cần dòng import trên. @import nạp nguyên văn — không tiết kiệm token. Kiểm bằng /context. -->

## Riêng cho Claude Code

- Dùng plan mode khi sửa: <các thư mục rủi ro cao>.
- Kết thúc phiên dài hoặc trước `/compact`: cập nhật điểm dừng và bàn giao ngay trong `docs/progress.md`.

<!-- Claude Code đọc lại CLAUDE.md gốc sau /compact; mục dưới là chỉ dẫn cho bộ nén. Hook SessionStart/compact trong.claude/settings.json bơm lại block đợt của docs/progress.md. -->

# Compact instructions

Khi compact, giữ: RUN-ID và AC đang làm, danh sách file đã sửa, lệnh kiểm + lỗi gần nhất chưa đóng, câu hỏi đang chờ người dùng. Ý "việc kế tiếp" trong hội thoại không phải quyền chạy.
