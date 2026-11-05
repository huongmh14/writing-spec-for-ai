# Auto Guide - Decision Tree

Visual decision tree cho auto-guide detection.

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
├─ Signal: demo/nhanh/prototype?
│  └─ YES → writing-spec-simple (demo mode)
│
├─ Signal: có ý tưởng mới?
│  └─ YES → idea-to-spec
│
└─ Không có signal rõ ràng?
   └─ Hỏi user clarifying question (max 1-2 câu)
```

---

## Signal Priority Order

Khi có nhiều signals, ưu tiên theo thứ tự:

1. **Bug/Error** → systematic-debugging (highest priority)
2. **Lần đầu/Explore** → explore
3. **Dự án mới/Docs** → writing-spec-simple hoặc writing-spec-for-ai
4. **Requirements/Plan** → writing-plans hoặc code trực tiếp
5. **Review** → code-review
6. **Refactor** → safe-refactor
7. **TDD** → tdd
8. **Verify** → verification-before-completion
9. **Demo** → writing-spec-simple (demo mode)
10. **Idea** → idea-to-spec

---

## Context Signals to Check

| Signal Type | What to Check |
|-------------|---------------|
| Keywords | User message contains trigger words |
| Project state | AGENTS.md exists? File count? |
| Git state | Branch? Changes? Commits? |
| Task size | Files affected? Components? |
| User intent | Demo? Production? Learning? |
