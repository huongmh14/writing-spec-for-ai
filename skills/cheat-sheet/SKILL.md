---
name: cheat-sheet
description: Cheat sheet when-to-use cho từng skill kèm ví dụ thực tế
license: MIT
---

# Cheat Sheet - Khi Nào Dùng Skill Nào

## Quick Lookup

**Bấm Ctrl+F tìm từ khóa tình huống của bạn:**
- bug, lỗi, fail → systematic-debugging
- mới vào, chưa hiểu, explore → explore
- review, PR, branch → code-review
- plan, requirements, spec → writing-plans
- refactor, tái cấu trúc → safe-refactor
- test-first, TDD → tdd
- dự án mới, AGENTS.md → writing-spec-simple hoặc writing-spec-for-ai
- verify, check, done → verification-before-completion

---

## Core Skills (Cần Thường Dùng)

### explore
**Khi nào dùng:**
- Lần đầu vào codebase, không biết file nào chứa logic cần tìm
- Cần hiểu flow của một feature (vd: authentication, payment)
- Grep không đủ, cần semantic search

**Ví dụ:**
- "Làm sao authentication hoạt động trong project này?"
- "Điểm entry của API này ở đâu?"
- "Data flow từ API xuống database đi qua đâu?"

**KHÔNG dùng khi:**
- Đã biết chính xác file cần đọc → đọc trực tiếp
- Chỉ cần grep tên hàm/variable → dùng grep

---

### systematic-debugging
**Khi nào dùng:**
- Test failure
- Bug ở production
- Unexpected behavior
- Build failure
- Performance problem

**Ví dụ:**
- "Test `test_login` fail, tìm lỗi giúp tôi"
- "API này trả 500, không biết tại sao"
- "Deploy thất bại, check giúp tôi"

**QUAN TRỌNG:**
- KHÔNG fix trước khi hiểu root cause
- Luôn hoàn thành Phase 1 (Root Cause Investigation) trước khi đề xuất fix

---

### code-review
**Khi nào dùng:**
- Review PR/branch trước khi merge
- Review work-in-progress changes
- Review "since X" (commit/branch/tag)

**Ví dụ:**
- "Review branch feature-login cho tôi"
- "Review changes từ commit abc123 đến HEAD"
- "Check PR #123 có đúng spec không"

**Kết quả:**
- Standards axis: có tuân thủ coding standards của repo không?
- Spec axis: có implement đúng issue/spec không?

---

### verification-before-completion
**Khi nào dùng:**
- Sắp xong task, cần verify trước khi commit
- Bạn yêu cầu "check xem đã xong chưa"
- Trước khi tạo PR

**Ví dụ:**
- "Verify code đã đúng chưa"
- "Check xem mọi test pass chưa"
- "Confirm implement đã đúng spec"

**Yêu cầu:**
- Chạy verification commands
- Show bằng chứng (test output, build status)
- KHÔNG claim xong nếu chưa verify

---

## Process Skills (Khi Cần Quy Trình)

### writing-plans
**Khi nào dùng:**
- Có spec/requirements cần implement
- Task lớn, cần chia nhỏ
- Muốn plan rõ ràng trước khi code

**Ví dụ:**
- "Viết plan implement API user management"
- "Chia nhỏ task cho feature search và filter"
- "Plan implement cache layer"

**Kết quả:**
- File plan ở `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`
- Mỗi task có: Files, Interfaces, Steps với checkbox
- Review Focus: các edge cases cần test

**KHÔNG dùng khi:**
- Task nhỏ (1-2 file, logic đơn giản) → code trực tiếp

---

### tdd
**Khi nào dùng:**
- User yêu cầu "TDD" hoặc "test-first"
- Muốn viết test trước code
- Cần test suite cho feature mới

**Ví dụ:**
- "TDD feature authentication"
- "Viết test cho API payment trước khi implement"
- "Red-green-refactor để fix bug này"

**Flow:**
1. Write failing test (RED)
2. Implement minimal code to pass (GREEN)
3. Refactor (REFACTOR)

---

### writing-spec-simple
**Khi nào dùng:**
- Dự án mới < 50 files
- User mới bắt đầu, chưa quen docs
- AI tự động đề xuất khi lần đầu vào project

**Ví dụ:**
- "Viết AGENTS.md cho dự án này"
- "Chuẩn hoá docs cho AI agent"
- "Dự án này chưa có spec, viết giúp tôi"

**Kết quả:**
- `AGENTS.md` đơn giản với tech stack, commands, conventions
- `glossary.md` nếu cần
- Specs đơn giản cho từng feature

**KHÔNG dùng khi:**
- Dự án ≥ 50 files → dùng writing-spec-for-ai
- Đã có AGENTS.md hợp lý

---

### writing-spec-for-ai
**Khi nào dùng:**
- Dự án lớn ≥ 50 files
- Team nhiều người/agent làm việc song song
- Cần formal process với 3 cổng review
- User nói "viết AGENTS.md", "chuẩn hoá docs cho agent"

**Ví dụ:**
- "Viết AGENTS.md cho dự án enterprise này"
- "Chuẩn hoá tài liệu để AI agent làm việc hiệu quả"
- "Dự án này chưa có spec, viết giúp tôi"

**Kết quả:**
- `AGENTS.md` đầy đủ với ranh giới, DoD, quy trình
- `CONSTRAINTS.md` nếu cần
- `glossary.md`, `decisions.md`, `specs/` đầy đủ
- 3 cổng review: đề xuất → phản biện → thử docs

**KHÔNG dùng khi:**
- Dự án nhỏ < 50 files → dùng writing-spec-simple

---

## When NOT to Use (cheat-sheet)

- Khi bạn cần auto-guidance → dùng `auto-guide` thay vì cheat-sheet
- Khi đã xác định skill cụ thể → mở skill trực tiếp
- Khi cần implementation details → cheat-sheet chỉ là lookup table

---

## Quick Decision Tree

```
Tình huống của bạn?
 Lần đầu vào project?
→   explore → (nếu chưa docs) writing-spec-simple hoặc writing-spec-for-ai
 Có bug?
→   systematic-debugging → fix → verification-before-completion
 Cần implement feature?
→   Task nhỏ? → code → verification-before-completion
→   Task lớn? → writing-plans → execute → verification-before-completion
 Cần review?
→   code-review
 Cần refactor?
→   safe-refactor
 Cần test?
→   Test-first? → tdd
→   E2E? → playwright
 Cần research?
→   research / code-research / feature-research
 Cần UI/UX?
→   impeccable / ui-ux-pro-max
```

---

**Nhớ:** Nếu không biết skill nào phù hợp, nói với AI:
```
"Tôi đang <tình huống>, nên dùng skill nào?"
```

AI sẽ tự động đề xuất qua `auto-guide`.
