---
name: <kebab-case, ≤ 64 ký tự, ví dụ adding-module>
description: Kích hoạt khi <từ khoá người dùng hay nói, tín hiệu cụ thể> trong repo <tên>. <Kết quả đầu ra, ngôi thứ ba, ≤ 450 ký tự; không tóm tắt các bước làm việc bên trong để tránh agent bỏ qua đọc thân file.>
---

<!-- Đặt tại .agents/skills/<name>/SKILL.md (Antigravity, Codex…) hoặc .claude/skills/<name>/SKILL.md.
Chỉ tạo khi quy trình đã lặp ≥ 2 lần. Body < 500 dòng; reference sâu 1 cấp.
Workflow có tác dụng phụ (deploy, xoá): Claude Code thêm `disable-model-invocation: true`. -->

# <Tên>

Spec/luật: SPEC-…, AGENTS.md mục …

## Các bước

<!-- Độ tự do: thao tác dễ vỡ (migration, xoá, phát hành) → lệnh chính xác/script, không để agent tự chế.
Việc cần phán đoán (review, thiết kế) → nguyên tắc + ví dụ. -->

1. <lệnh/thao tác cụ thể, đường dẫn thật>
2.

## Kiểm tra trước khi xong

- [ ] <lệnh phải xanh>

## Gotchas

<!-- Sửa code đụng tới một gotcha thì sửa/xoá gotcha đó trong cùng PR. Gotcha sai còn hại hơn không có. -->

- <triệu chứng> → <nguyên nhân> → <cách tránh> · kiểm lần cuối YYYY-MM-DD

<!-- Kỹ năng chung (TDD, debug, review): gọi tên skill global, không chép lại. -->
