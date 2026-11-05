---
name: auto-guide
description: AI tự động phát hiện tình huống và đề xuất skill/lựa chọn phù hợp cho người dùng - không để user đoán phải làm gì
license: MIT
trigger_phrases:
  - "nên dùng skill nào"
  - "giúp tôi chọn skill"
  - "tôi đang <tình huống>"
do_not_use:
  - "Khi user đã chỉ định skill cụ thể"
  - "Khi task đơn giản không cần routing"
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

### 2. Luôn Cung Cấp Lý do Rõ Ràng

Format đề xuất:
```
Đề xuất: <skill-name>
Lý do: <context analysis + signals>
Kết quả mong đợi: <what will happen>
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
**→ Đề xuất:** `systematic-debugging`

### Signal 2: Lần đầu vào project / chưa hiểu codebase
**Keywords:** mới vào, lần đầu, chưa hiểu, xem project, understand, explore, codebase
**→ Đề xuất:** `explore`

### Signal 3: Dự án mới / chưa có docs cho AI
**Keywords:** dự án mới, new project, AGENTS.md, docs cho AI, chuẩn hoá docs
**Detection:** Project < 50 files → `writing-spec-simple`, ≥ 50 files → `writing-spec-for-ai`
**→ Đề xuất:** `writing-spec-simple` hoặc `writing-spec-for-ai`

### Signal 4: Có requirements/spec cần implement
**Keywords:** implement, feature, requirements, spec, design doc, plan
**Detection:** Task nhỏ → code trực tiếp, Task lớn → `writing-plans`
**→ Đề xuất:** `writing-plans` hoặc code trực tiếp

### Signal 5: Review code / PR / branch
**Keywords:** review, PR, branch, changes, diff, merge
**→ Đề xuất:** `code-review`

### Signal 6: Refactor / tái cấu trúc
**Keywords:** refactor, tái cấu trúc, cleanup, organize, extract, split
**→ Đề xuất:** `safe-refactor`

### Signal 7: Test-first / TDD
**Keywords:** TDD, test-first, test trước, red-green-refactor
**→ Đề xuất:** `tdd`

### Signal 8: Sắp xong / cần verify
**Keywords:** xong, done, complete, verify, check, confirm
**→ Đề xuất:** `verification-before-completion`

### Signal 9: Demo / Nhanh / Prototype
**Keywords:** demo, nhanh, prototype, POC, thử nghiệm
**→ Đề xuất:** `writing-spec-simple` (demo mode)

### Signal 10: Có ý tưởng mới
**Keywords:** ý tưởng, idea, mới, concept, brainstorm
**→ Đề xuất:** `idea-to-spec`

---

## Decision Tree

Xem chi tiết tại `references/decision-tree.md`

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
6. Demo nhanh?
7. Có ý tưởng mới?

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

## Ví Dụ

Xem chi tiết tại `references/examples.md`

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
