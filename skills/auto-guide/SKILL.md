---
name: auto-guide
description: AI tự động phát hiện tình huống và đề xuất skill/lựa chọn phù hợp cho người dùng - không để user đoán phải làm gì
license: MIT
---

# Auto Guide - AI Tự Động Điều Hướng

**Mục tiêu:** Người dùng KHÔNG cần biết skill nào phù hợp. AI tự động phát hiện tình huống và đề xuất skill/lựa chọn rõ ràng với lý do.

**Khi nào kích hoạt:**
- User nói chung chung: "fix lỗi này", "implement feature này", "xem project này"
- User không nhắc skill cụ thể
- AI không chắc user muốn gì → auto-guide active

---

## Nguyên Tắc Vàng

### 1. AI Phải Chọn, Không Để User Đoán

**SAI:**
- "Bạn có muốn dùng explore hay writing-plans?"
- "Skill nào bạn thích?"

**ĐÚNG:**
- "Tôi đề xuất dùng `explore` vì bạn chưa hiểu codebase. Sau đó dùng `writing-plans` vì task cần chia nhỏ."
- "Theo context, nên dùng `systematic-debugging` vì đây là bug, chưa hiểu root cause."

### 2. Luôn Cung Cấp Lý Do Rõ Ràng

Format đề xuất:
```
Đề xuất: <skill-name>
Lý do: <context analysis + signals>
Kết quả mong đợi: <what will happen>
```

Ví dụ:
```
Đề xuất: systematic-debugging
Lý do:
- User nói "test fail" → signal bug
- Chưa có investigation → chưa hiểu root cause
- Không nên fix trước khi hiểu

Kết quả mong đợi:
- Tìm root cause
- Fix đúng chỗ
- Tránh fix sai → lại bug khác
```

### 3. Nếu Có Nhiều Lựa Chọn → Đưa Ra Clear Options

Format:
```
Tình huống của bạn: <context>

Lựa chọn 1: <skill A>
  Khi nào chọn: <condition>
  Lý do: <reason>
  Ví dụ: <example>

Lựa chọn 2: <skill B>
  Khi nào chọn: <condition>
  Lý do: <reason>
  Ví dụ: <example>

Bạn nên chọn: <recommendation> vì <primary reason>
```

### 4. Không Phân Tích Quá Lâu - Phải Có Hành Động

- Maximum 2-3 commands để detect context
- Sau đó → propose action immediately
- Không ask generic questions

---

## Detection Rules - Phát Hiện Tình Huống

### Signal 1: Bug / Error / Failure

**Keywords:** bug, lỗi, fail, error, wrong, không đúng, crash, 500, 404, broken

**Context signals:**
- User nói "test fail" / "test không pass"
- User paste error message
- User nói "API này trả 500"
- User nói "deploy thất bại"

**→ Đề xuất:** `systematic-debugging`

**Lý do template:**
```
Đề xuất: systematic-debugging
Lý do:
- Phát hiện signal: bug/error/failure
- Chưa có root cause investigation
- VI PHẠM luật: không fix trước khi hiểu nguyên nhân

Kết quả:
- Tìm root cause
- Fix đúng chỗ
- Test để verify
```

---

### Signal 2: Lần đầu vào project / chưa hiểu codebase

**Keywords:** mới vào, lần đầu, chưa hiểu, xem project, understand, explore, codebase

**Context signals:**
- User nói "lần đầu vào project này"
- User nói "xem giúp tôi project này làm gì"
- User không biết file nào chứa logic
- User hỏi "architecture này như thế nào"

**→ Đề xuất:** `explore`

**Lý do template:**
```
Đề xuất: explore
Lý do:
- Phát hiện signal: lần đầu/ chưa hiểu codebase
- Cần mapping codebase trước khi làm gì
- Grep không đủ → cần semantic search

Kết quả:
- Hiểu architecture
- Biết file nào chứa logic cần tìm
- Có context để tiếp tục
```

---

### Signal 3: Dự án mới / chưa có docs cho AI

**Keywords:** dự án mới, new project, AGENTS.md, docs cho AI, chuẩn hoá docs

**Context signals:**
- User nói "dự án mới"
- User nói "viết AGENTS.md"
- User nói "chuẩn hoá docs cho agent"
- Không có `AGENTS.md` trong project
- AI lần đầu làm việc với project

**→ Đề xuất:** `writing-spec-simple` (hoặc `writing-spec-for-ai` nếu project lớn)

**Detection project size:**
- Check số files: < 50 → `writing-spec-simple`
- Check số files: ≥ 50 → `writing-spec-for-ai`

**Lý do template:**
```
Đề xuất: writing-spec-simple
Lý do:
- Phát hiện signal: dự án mới / chưa có docs
- Project size: < 50 files → bản simple đủ
- AI cần docs để làm việc hiệu quả

Kết quả:
- AGENTS.md với tech stack, commands, conventions
- Specs cho từng feature (nếu cần)
- AI hiểu project → code chính xác hơn
```

---

### Signal 4: Có requirements/spec cần implement

**Keywords:** implement, feature, requirements, spec, design doc, plan

**Context signals:**
- User nói "implement feature X"
- User nói "có spec này, code giúp tôi"
- User nói "viết plan cho feature này"
- User paste requirements

**Detection task size:**
- Task nhỏ (1-2 files, logic đơn giản) → code trực tiếp
- Task lớn (nhiều files, nhiều components) → `writing-plans`

**→ Đề xuất:** `writing-plans` (nếu task lớn) hoặc code trực tiếp (nếu task nhỏ)

**Lý do template (task lớn):**
```
Đề xuất: writing-plans
Lý do:
- Phát hiện signal: có requirements/spec
- Task size: lớn (nhiều files/components)
- Cần chia nhỏ task trước khi code

Kết quả:
- Plan rõ ràng từng task
- Mỗi task có steps với checkbox
- Dễ track progress
```

---

### Signal 5: Review code / PR / branch

**Keywords:** review, PR, branch, changes, diff, merge

**Context signals:**
- User nói "review branch này"
- User nói "check PR #123"
- User nói "review changes từ commit X"

**→ Đề xuất:** `code-review`

**Lý do template:**
```
Đề xuất: code-review
Lý do:
- Phát hiện signal: review/PR/branch
- Cần check Standards + Spec axis
- AI sẽ analyze diff vs fixed point

Kết quả:
- Standards axis: tuân thủ coding standards?
- Spec axis: implement đúng requirements?
- Report chi tiết từng finding
```

---

### Signal 6: Refactor / tái cấu trúc

**Keywords:** refactor, tái cấu trúc, cleanup, organize, extract, split

**Context signals:**
- User nói "refactor class này"
- User nói "tách module ra"
- User nói "cleanup code rối"

**→ Đề xuất:** `safe-refactor`

**Lý do template:**
```
Đề xuất: safe-refactor
Lý do:
- Phát hiện signal: refactor/cleanup
- Cần giữ behavior, chỉ thay đổi structure
- QUAN TRỌNG: không đổi behavior

Kết quả:
- Refactor an toàn
- Test vẫn pass
- Structure tốt hơn
```

---

### Signal 7: Test-first / TDD

**Keywords:** TDD, test-first, test trước, red-green-refactor

**Context signals:**
- User nói "TDD feature này"
- User nói "viết test trước rồi code"
- User yêu cầu "test-driven"

**→ Đề xuất:** `tdd`

**Lý do template:**
```
Đề xuất: tdd
Lý do:
- Phát hiện signal: TDD/test-first
- User yêu cầu test-first approach
- Flow: RED → GREEN → REFACTOR

Kết quả:
- Failing test trước
- Implement minimal code
- Refactor khi cần
```

---

### Signal 8: Sắp xong / cần verify

**Keywords:** xong, done, complete, verify, check, confirm

**Context signals:**
- User nói "đã xong, check giúp tôi"
- User nói "verify code này"
- User nói "confirm implement đúng không"

**→ Đề xuất:** `verification-before-completion`

**Lý do template:**
```
Đề xuất: verification-before-completion
Lý do:
- Phát hiện signal: sắp xong/cần verify
- LUÔN verify trước khi claim done
- Bằng chứng test/build trước khi nói "xong"

Kết quả:
- Chạy verification commands
- Show test output
- Bằng chứng rõ ràng
```

---

## Decision Tree Tự Động

```
User request → Analyze context
│
├─ Signal: bug/error/failure?
│  └─ YES → systematic-debugging
│
├─ Signal: lần đầu/ chưa hiểu codebase?
│  └─ YES → explore
│
├─ Signal: dự án mới/ chưa có docs?
│  ├─ Project < 50 files → writing-spec-simple
│  └─ Project ≥ 50 files → writing-spec-for-ai
│
├─ Signal: có requirements/spec?
│  ├─ Task nhỏ → code trực tiếp
│  └─ Task lớn → writing-plans
│
├─ Signal: review/PR/branch?
│  └─ YES → code-review
│
├─ Signal: refactor/cleanup?
│  └─ YES → safe-refactor
│
├─ Signal: TDD/test-first?
│  └─ YES → tdd
│
├─ Signal: sắp xong/cần verify?
│  └─ YES → verification-before-completion
│
└─ Không có signal rõ ràng?
   └─ Hỏi user clarifying question (max 1-2 câu)
```

---

## Khi Không Có Signal Rõ Ràng

Nếu user nói chung chung không phát hiện được signal:

❌ **SAI:**
- "Bạn muốn làm gì?"
- "Skill nào bạn thích?"

✅ **ĐÚNG:**
```
Tôi chưa chắc chắn tình huống của bạn. Giúp tôi rõ hơn:

Bạn đang:
1. Fix bug?
2. Implement feature mới?
3. Review code?
4. Khám phá project mới?
5. Viết plan cho task lớn?

Chọn số hoặc mô tả ngắn.
```

**Sau khi user chọn → AI lại auto-guide theo signal tương ứng.**

---

## Response Format Template

### Single Proposal (Rõ Ràng)

```
=== Tình Huống Của Bạn ===
<Context summary>

=== Đề Xuất Của Tôi ===
Skill: <skill-name>

Lý do:
- Signal 1: <first signal>
- Signal 2: <second signal>
- Conclusion: <why this skill>

Kết quả mong đợi:
- <what will happen>
- <benefit>

=== Bước Tiếp Theo ===
Tôi sẽ: <action 1>
Sau đó: <action 2>

Bạn có đồng ý không? (có/không hoặc chỉnh sửa)
```

### Multiple Options (Khi Có Nhiều Lựa Chọn)

```
=== Tình Huống Của Bạn ===
<Context summary>

=== Lựa Chọn ===

Lựa chọn 1: <skill A>
  Khi nào chọn: <condition>
  Lý do: <reason>
  Ví dụ: <example>
  Ưu điểm: <pros>
  Nhược điểm: <cons>

Lựa chọn 2: <skill B>
  Khi nào chọn: <condition>
  Lý do: <reason>
  Ví dụ: <example>
  Ưu điểm: <pros>
  Nhược điểm: <cons>

=== Đề Xuất Của Tôi ===
Tôi đề xuất: <recommendation>
Vì: <primary reason>

Bạn chọn lựa chọn nào? (1/2 hoặc mô tả khác)
```

---

## Ví Dụ Thực Tế

### Ví dụ 1: User nói "fix lỗi này"

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

### Ví dụ 2: User nói "implement user authentication"

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

### Ví dụ 3: User nói "lần đầu vào project này"

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

## Quy Tắc Cho AI

### Phải Làm

1. **Luôn analyze context trước khi đề xuất**
   - Check keywords trong user message
   - Check project state (có AGENTS.md không, số files)
   - Check git state (có changes không, có branch không)

2. **Luôn cung cấp lý do rõ ràng**
   - Tại sao chọn skill này?
   - Context signals là gì?
   - Kết quả mong đợi là gì?

3. **Luôn có bước tiếp theo cụ thể**
   - Tôi sẽ làm gì?
   - Bạn cần cung cấp gì?
   - Khi nào dừng để review?

4. **Nếu không chắc → hỏi clarifying question**
   - Tối đa 1-2 câu
   - Cung cấp options để chọn
   - Không để user đoán

### Không Được Làm

1. **Không hỏi generic questions**
   - ❌ "Bạn muốn làm gì?"
   - ❌ "Skill nào bạn thích?"
   - ✅ "Bạn đang fix bug hay implement feature?"

2. **Không để user chọn skill**
   - ❌ "Bạn muốn dùng explore hay writing-plans?"
   - ✅ "Tôi đề xuất explore vì X, sau đó writing-plans vì Y"

3. **Không phân tích quá lâu**
   - Maximum 2-3 commands để detect
   - Sau đó → propose action immediately

4. **Không dùng thuật ngữ phức tạp**
   - Giữ language đơn giản
   - Nếu dùng thuật ngữ → giải thích ngay

---

## Integration Với Các Skill Khác

Khi auto-guide đề xuất skill X → skill X cũng phải:
- Giữ context từ auto-guide
- Không để user lost
- Có clear handoff

Ví dụ:
```
auto-guide → "Tôi đề xuất systematic-debugging"
→ systematic-debugging: "Theo đề xuất, tôi sẽ bắt đầu Phase 1: Root Cause Investigation..."
```

---

## Checklist Trước Khi Đề Xuất

AI phải check:
- [ ] Đã analyze context (keywords, project state, git state)
- [ ] Đã detect signal rõ ràng
- [ ] Đã có lý do cho đề xuất
- [ ] Đã có bước tiếp theo cụ thể
- [ ] Language đơn giản, không thuật ngữ lạ
- [ ] Không để user đoán

---

**Tóm lại:** AI phải là navigator, không phải tour guide. User nói "đưa tôi đến nơi", AI tự động tìm đường, không hỏi "bạn muốn đi đường nào?".

## When NOT to Use

- User explicitly names a specific skill
- User provides clear technical direction
- Simple one-off tasks where auto-detection adds overhead
