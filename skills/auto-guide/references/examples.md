# Auto Guide - Detailed Examples

Chi tiết ví dụ response format cho auto-guide.

## Ví dụ 1: User nói "fix lỗi này"

```
User: "fix lỗi này"
AI: "Tôi cần xem error/help để hiểu rõ hơn. Bạn có error message không?"

User: [paste error]
AI:
=== Tình Huống Của Bạn ===
Phát hiện: test failure - "AssertionError: expected 200 but got 500"
Chưa có: root cause investigation

=== Đề Xuất Của Tôi ===
Skill: systematic-debugging

Lý do:
- Signal: test failure → bug
- Chưa hiểu root cause → chưa nên fix
- VI PHẠM luật: không fix trước khi hiểu nguyên nhân

Kết quả mong đợi:
- Tìm root cause tại đâu trả 500
- Fix đúng chỗ
- Test để verify fix đúng

=== Bước Tiếp Theo ===
Tôi sẽ:
1. Đọc error message
2. Reproduce bug
3. Trace code flow để tìm root cause
4. Đề xuất fix
5. Verify với test

Bạn có đồng ý không?
```

---

## Ví dụ 2: User nói "implement user authentication"

```
User: "implement user authentication"

AI:
=== Tình Huống Của Bạn ===
Phát hiện: feature request - user authentication
Task size: lớn (multi-component: login, register, session)

=== Đề Xuất Của Tôi ===
Skill: writing-plans

Lý do:
- Signal: implement feature mới
- Task size: lớn → cần chia nhỏ
- Cần plan rõ ràng từng task

Kết quả mong đợi:
- Plan với các task: register, login, session, password reset
- Mỗi task có steps + checkbox
- Dễ track progress

=== Bước Tiếp Theo ===
Tôi sẽ:
1. Xem tech stack hiện tại
2. Chia nhỏ thành các task
3. Viết plan tại docs/superpowers/plans/
4. Review plan với bạn

Bạn có đồng ý không? Hoặc bạn muốn code trực tiếp vì task đơn giản?
```

---

## Ví dụ 3: User nói "lần đầu vào project này"

```
User: "lần đầu vào project này"

AI:
=== Tình Huống Của Bạn ===
Phát hiện: lần đầu vào project
Chưa có: AGENTS.md (AI docs)
Project size: 30 files

=== Đề Xuất Của Tôi ===
Skill: explore → writing-spec-simple

Lý do:
- Signal: lần đầu → cần hiểu codebase
- Không có AGENTS.md → nên chuẩn hoá docs
- Project < 50 files → bản simple đủ

Kết quả mong đợi:
- explore: hiểu architecture, structure
- writing-spec-simple: AGENTS.md với tech stack, commands
- AI có context → làm việc hiệu quả hơn

=== Bước Tiếp Theo ===
Tôi sẽ:
1. explore codebase (5-10 phút)
2. Đề xuất cấu trúc docs (3-5 phút)
3. Viết AGENTS.md (10-15 phút)
4. Review với bạn

Bạn có đồng ý không? Hoặc chỉ explore thôi không cần docs?
```

---

## Ví dụ 4: User nói "demo nhanh project này"

```
User: "demo nhanh project này"

AI:
=== Tình Huống Của Bạn ===
Phát hiện: demo/prototype mode
Cần: docs nhanh, không formal

=== Đề Xuất Của Tôi ===
Skill: writing-spec-simple (demo mode)

Lý do:
- Signal: demo/nhanh/prototype
- Cần docs nhanh, không formal process
- Chỉ cần AGENTS.md đơn giản

Kết quả mong đợi:
- AGENTS.md với tech stack + lệnh trong 2-3 phút
- Không cần specs, glossary, decisions
- Sẵn sàng demo ngay

=== Bước Tiếp Theo ===
Tôi sẽ:
1. Hỏi tech stack và lệnh build/test
2. Tạo AGENTS.demo.md (2-3 phút)
3. Review với bạn

Bạn có đồng ý không?
```
