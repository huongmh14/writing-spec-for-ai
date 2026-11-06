# Auto Guide - Decision Tree

Visual decision tree for auto-guide detection.

```
User request  Analyze context
│
├─ Signal: bug/error/failure?
│  └─ YES  systematic-debugging
│
├─ Signal: first time / unfamiliar codebase?
│  └─ YES  explore
│
├─ Signal: new project / no docs?
│  ├─ Project < 50 files  writing-spec-simple
│  └─ Project >= 50 files  writing-spec-for-ai
│
├─ Signal: has requirements/spec?
│  ├─ Small task  code directly
│  └─ Large task  writing-plans
│
├─ Signal: review/PR/branch?
│  └─ YES  code-review
│
├─ Signal: refactor/cleanup?
│  └─ YES  safe-refactor
│
├─ Signal: TDD/test-first?
│  └─ YES  tdd
│
├─ Signal: about to finish / needs verify?
│  └─ YES  verification-before-completion
│
├─ Signal: demo/fast/prototype?
│  └─ YES  writing-spec-simple (demo mode)
│
├─ Signal: new idea?
│  └─ YES  idea-to-spec
│
└─ No clear signal?
   └─ Ask user a clarifying question (max 1-2)
```

---

## Signal Priority Order

When multiple signals fire, prioritize in this order:

1. **Bug/Error**  systematic-debugging (highest priority)
2. **First time/Explore**  explore
3. **New project/Docs**  writing-spec-simple or writing-spec-for-ai
4. **Requirements/Plan**  writing-plans or code directly
5. **Review**  code-review
6. **Refactor**  safe-refactor
7. **TDD**  tdd
8. **Verify**  verification-before-completion
9. **Demo**  writing-spec-simple (demo mode)
10. **Idea**  idea-to-spec

---

## Context Signals to Check

| Signal Type | What to Check |
|-------------|---------------|
| Keywords | User message contains trigger words |
| Project state | AGENTS.md exists? File count? |
| Git state | Branch? Changes? Commits? |
| Task size | Files affected? Components? |
| User intent | Demo? Production? Learning? |
